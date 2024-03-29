##functions for processing compositional microbiome datasets
#all scripts written by BPB, 062519

#ERROR PROTECTION FUNCTIONS
format.ASV.tab <- function(ps){
  if(as.logical(class(phyloseq::otu_table(ps))[1] == "otu_table") && 
     as.logical(taxa_are_rows(phyloseq::otu_table(ps)) == TRUE)){
    asv.tab <- as.matrix(phyloseq::otu_table(ps))
  } else {
    asv.tab <- as.matrix(t(phyloseq::otu_table(ps)))
  }
  asv.tab
}

format.parameter.string <- function(string){
  string <- gsub(pattern = "c(|)", replacement = "", x = string)
  string[2] <- gsub(pattern = ":", replacement = ", ", x = string[2])
  string <- strsplit(string, split = ", ")
  string <- as.numeric(paste0(c(string[[2]], string[[3]])))
  string
}

format.long <- function(df){
  ctc <- rep(colnames(df)[2], nrow(df))
  ctm <- rep(colnames(df)[3], nrow(df))
  tvv <- rep(df[,1], 2)
  th <- c(df[,2], df[, 3])
  
  df2 <- cbind.data.frame(c(ctc, ctm), tvv, th)
  colnames(df2) <- c("cgroup", "threshold.value", "taxa.hits")
  df2
}

#PLOTTING FUNCTIONS
plot.threshold <- function(est.obj, y=NULL, x=NULL, PFT=NULL, RAT=NULL, CVT=NULL, taxrank=NULL){
  #never gray
  ggplot2::theme_set(theme_bw())
  
  #error checking
  if (!is.null(x) && is.null(y)){
    stop("Please provide variables for both axes")
  }
  
  if (is.null(x) && !is.null(y)){
    stop("Please provide variables for both axes")
  }
  
  #plot either WS, AS or taxonomic filter figs
  
  #begin WS threshold plots
  if (is.data.frame(est.obj)){
    df <- format.long(est.obj)
    
    plot1 <- ggplot2::ggplot(data = df, aes(x=threshold.value, y=taxa.hits, color=cgroup)) + 
      ggplot2::geom_line(size=2, alpha=0.7) + ggplot2::scale_color_manual(values = c("orange", "steelblue2"), labels = c("Total", "Matches")) +
      ggplot2::theme(axis.text.y = element_text(size = 15, colour = "black"),
                     axis.text.x = element_text(size = 15, colour = "black", angle = 315, vjust = 0.7),
                     axis.title.x = element_text(size = 15, colour = "black"),
                     axis.title.y = element_text(size = 15),
                     legend.title = element_text(size = 0),
                     legend.text = element_text(size = 15, colour = "black"),
                     legend.position = "top",
                     legend.key = element_rect(size = 5),
                     legend.key.size = unit(2.5, 'lines')) + 
      labs(x="Threshold value", y="Taxon count")
    
    plot2 <- ggplot2::ggplot(data = est.obj, aes(x = threshold.value, y = read.percent)) + ggplot2::geom_line(size=2, color="orangered1") + 
      ggplot2::theme(axis.text.y = element_text(size = 15, colour = "black"),
                     axis.text.x = element_text(size = 15, colour = "black", angle = 315, vjust = 0.7),
                     axis.title.x = element_text(size = 15, colour = "black"),
                     axis.title.y = element_text(size = 15, colour = "black")) +
      labs(x="Threshold value", y="Read percent")
    
    cowplot::plot_grid(plot1, plot2, labels = "AUTO")
    #begin ASV threshold plots
  } else if (!is.null(x) && !is.null(y)){
    
    #create df of ASV data and remove filtered taxa
    ASV.df <- est.obj$ASV.filtering.stats
    ASV.df.f <- ASV.df[complete.cases(ASV.df[,5]),] #remove filtered taxa
    
    #plots
    if (x == "P" && y =="RA"){
      #plot RA by prevalence
      asv.plot <- ggplot2::ggplot(data = ASV.df.f, aes(x = ASV.prevalence.percent, y = ASV.read.percent, color=Phylum)) + ggplot2::geom_point(size=3) + 
        ggplot2::facet_wrap(taxrank, scales = "fixed") + ggplot2::scale_y_log10() +
        ggplot2::theme(axis.text.x = element_text(size = 10, angle = 315, vjust = 0.2), 
                       legend.position = "right",
                       strip.text = element_text(size=11, color="white"),
                       strip.background = element_rect(fill = "black")) +
        ggplot2::geom_hline(yintercept = RAT, lty=2) +
        ggplot2::geom_vline(xintercept = PFT) +
        ggplot2::labs(y="ASV abundance (%)", x= "ASV prevalence (%)")
      
      return(asv.plot)
      
    } else if (x == "P" && y =="CV"){
      #plot CV by prevalence
      asv.plot <- ggplot2::ggplot(data = ASV.df.f, aes(x = ASV.prevalence.percent, y = ASV.CV, color=Phylum)) + ggplot2::geom_point(size=3) + 
        ggplot2::facet_wrap(taxrank, scales = "fixed") + 
        ggplot2::theme(axis.text.x = element_text(size = 10, angle = 315, vjust = 0.2), 
                       legend.position = "right",
                       strip.text = element_text(size=11, color="white"),
                       strip.background = element_rect(fill = "black")) +
        ggplot2::geom_hline(yintercept = CVT, lty=2) +
        ggplot2::geom_vline(xintercept = PFT) +
        ggplot2::labs(y="ASV CV", x= "ASV prevalence (%)")
      
      return(asv.plot)
      
    } else if (x == "RA" && y =="CV"){
      #plot CV by RA
      asv.plot <- ggplot2::ggplot(data = ASV.df.f, aes(x = ASV.read.percent, y = ASV.CV, color=Phylum)) + ggplot2::geom_point(size=3) + 
        ggplot2::facet_wrap(taxrank, scales = "fixed") + ggplot2::scale_x_log10() +
        ggplot2::theme(axis.text.x = element_text(size = 10, angle = 315, vjust = 0.2), 
                       legend.position = "right",
                       strip.text = element_text(size=11, color="white"),
                       strip.background = element_rect(fill = "black")) +
        ggplot2::geom_hline(yintercept = CVT, lty=2) +
        ggplot2::geom_vline(xintercept = RAT) +
        ggplot2::labs(y="ASV CV", x= "ASV abundance (%)")
      
      return(asv.plot)
      
    } else if (x == "RA" && y =="P"){
      #plot prevalence by RA
      asv.plot <- ggplot2::ggplot(data = ASV.df.f, aes(x = ASV.read.percent, y = ASV.prevalence.percent, color=Phylum)) + ggplot2::geom_point(size=3) + 
        ggplot2::facet_wrap(taxrank, scales = "fixed") + ggplot2::scale_x_log10() +
        ggplot2::theme(axis.text.x = element_text(size = 10, angle = 315, vjust = 0.2), 
                       legend.position = "right",
                       strip.text = element_text(size=11, color="white"),
                       strip.background = element_rect(fill = "black")) +
        ggplot2::geom_hline(yintercept = PFT, lty=2) +
        ggplot2::geom_vline(xintercept = RAT) +
        ggplot2::labs(y="ASV prevalence (%)", x= "ASV abundance (%)")
      
      return(asv.plot)
      
    } else if (x == "CV" && y =="RA"){
      #plot RA by CV
      asv.plot <- ggplot2::ggplot(data = ASV.df.f, aes(x = ASV.CV, y = ASV.read.percent, color=Phylum)) + ggplot2::geom_point(size=3) + 
        ggplot2::facet_wrap(taxrank, scales = "fixed") + ggplot2::scale_y_log10() +
        ggplot2::theme(axis.text.x = element_text(size = 10, angle = 315, vjust = 0.2), 
                       legend.position = "right",
                       strip.text = element_text(size=11, color="white"),
                       strip.background = element_rect(fill = "black")) +
        ggplot2::geom_hline(yintercept = RAT, lty=2) +
        ggplot2::geom_vline(xintercept = CVT) +
        ggplot2::labs(y="ASV abundance (%)", x= "ASV CV")
      
      return(asv.plot)
      
    } else if (x == "CV" && y =="P"){
      #plot prevalence by CV
      asv.plot <- ggplot2::ggplot(data = ASV.df.f, aes(x = ASV.CV, y = ASV.prevalence.percent, color=Phylum)) + ggplot2::geom_point(size=3) + 
        ggplot2::facet_wrap(taxrank, scales = "fixed") + 
        ggplot2::theme(axis.text.x = element_text(size = 10, angle = 315, vjust = 0.2), 
                       legend.position = "right",
                       strip.text = element_text(size=11, color="white"),
                       strip.background = element_rect(fill = "black")) +
        ggplot2::geom_hline(yintercept = PFT, lty=2) +
        ggplot2::geom_vline(xintercept = CVT) +
        ggplot2::labs(y="ASV prevalence (%)", x= "ASV CV")
      
      return(asv.plot)
      
    }
    #begin AS threshold plots
  } else {
    #RA
    if (!is.null(est.obj$relative.abundance.filtering.stats)){
      RA.stats <- est.obj$relative.abundance.filtering.stats
      plot3 <- ggplot2::ggplot(data = RA.stats, aes(x = relative.abundance.filter, y = ASV.count)) + ggplot2::geom_line(size=2, color="steelblue2") + 
        ggplot2::theme(axis.text.y = element_text(size = 15, colour = "black"),
                       axis.text.x = element_text(size = 15, colour = "black", angle = 315, vjust = 0.7),
                       axis.title.x = element_text(size = 15, colour = "black"),
                       axis.title.y = element_text(size = 15, colour = "black")) +
        labs(x="Relative abundance threshold", y="Taxon count")
    } else {
      RA.stats <- NULL
      plot3 <- NULL
    }
    #CV
    if (!is.null(est.obj$CV.filtering.stats)){
      CV.stats <- est.obj$CV.filtering.stats
      plot4 <- ggplot2::ggplot(data = CV.stats, aes(x = CV.filter, y = ASV.count)) + ggplot2::geom_line(size=2, color="orangered1") + 
        ggplot2::theme(axis.text.y = element_text(size = 15, colour = "black"),
                       axis.text.x = element_text(size = 15, colour = "black", angle = 315, vjust = 0.7),
                       axis.title.x = element_text(size = 15, colour = "black"),
                       axis.title.y = element_text(size = 15, colour = "black")) +
        labs(x="CV threshold", y="Taxon count")
    } else {
      CV.stats <- NULL
      plot4 <- NULL
    }
    #P
    if (!is.null(est.obj$prevalence.filtering.stats)){
      P.stats <- est.obj$prevalence.filtering.stats
      plot5 <- ggplot2::ggplot(data = P.stats, aes(x = prevalence.filter, y = ASV.count)) + ggplot2::geom_line(size=2, color="forestgreen") + 
        ggplot2::theme(axis.text.y = element_text(size = 15, colour = "black"),
                       axis.text.x = element_text(size = 15, colour = "black", angle = 315, vjust = 0.7),
                       axis.title.x = element_text(size = 15, colour = "black"),
                       axis.title.y = element_text(size = 15, colour = "black")) +
        labs(x="Prevalence threshold", y="Taxon count")
    } else {
      P.stats <- NULL
      plot5 <- NULL
    }
    
    plist <- list(plot3, plot4, plot5)
    cowplot::plot_grid(labels = "AUTO", plotlist = plist[which(!sapply(plist, is.null))])
    
  }
}

#PROCESSING FUNCTIONS
#standardization 
standardize.median <- function(ps){
  median.rc <- median(phyloseq::sample_sums(ps))
  ps.t <- phyloseq::transform_sample_counts(ps, fun = function(x) round(median.rc * (x/sum(x))))
  ps.t
}

#parameter estimation
getWS <- function(ps, WSrange, controlID, controlFASTA=NULL, useREFSEQ=FALSE){
  
  #Build param lists
  l.t <- seq(from = WSrange[1], to = WSrange[2], by = WSrange[3])
  nt <- length(l.t)
  tvec <- c()
  svec <- c()
  pvec <- c()
  
  #build files for sequence matching if specified
  if (!is.null(controlFASTA)){
    nvec <- list()
    mvec <- c()
    cfasta <- ShortRead::readFasta(controlFASTA)
  }
  
  
  for (i in 1:nt){
    tryCatch({
      #loop through values
      ps.ws <- suppressMessages(WSfilter(ps = ps, WST = l.t[i]))
      asv.tab <- format.ASV.tab(ps.ws)
      
      #FILTERING
      tvec[i] <- nrow(asv.tab[which(asv.tab[,match(controlID, colnames(asv.tab))] != 0),])
      svec[i] <- sum(phyloseq::sample_sums(ps.ws))
      pvec[i] <- sum(phyloseq::sample_sums(ps.ws))/sum(phyloseq::sample_sums(ps))*100
      
      if (!is.null(controlFASTA)){
        if (isTRUE(useREFSEQ)){
          #from phyloseq refseq slot
          control.taxanames <- rownames(asv.tab[which(asv.tab[,match(controlID, colnames(asv.tab))] != 0),])
          nvec[[i]] <- phyloseq::refseq(ps.ws)[control.taxanames]
        } else {
          nvec[[i]] <- rownames(asv.tab[which(asv.tab[,match(controlID, colnames(asv.tab))] != 0),])
        }
        #calculate matches to control FASTA
        mvec[i] <- sum(sapply(nvec[[i]], function(x) any(grepl(x, as.character(ShortRead::sread(cfasta))))))
      }
      
    },
    error=function(e){cat("Warning :",conditionMessage(e), "\n")})
  }
  names(tvec) <- c(l.t)
  names(svec) <- c(l.t)
  names(pvec) <- c(l.t)
  if (!is.null(controlFASTA)){
    names(mvec) <- c(l.t)
  } else {
    mvec <- rep(NA, length(tvec))
  }
  
  df <- as.data.frame(cbind(as.numeric(paste0(names(tvec))), tvec, mvec, svec, pvec))
  colnames(df) <- c("threshold.value", "control.taxa.count", "control.taxa.matches", "read.count", "read.percent")
  rownames(df) <- seq(1:length(l.t))
  df
}

getCV <- function(ps, WST=NULL, CVrange){
  
  #WS filtering
  if(is.null(WST)){
    message('Not applying WS filter')
    ps.ws <- ps
  } else {
    ps.ws <- WSfilter(ps = ps, WST = WST)
  }
  #standardize to median sample depth
  ps.wsm <- standardize.median(ps.ws)
  
  #build param vectors
  if(is.null(CVrange)){
    dfc <- NULL
  } else {
    l.c <- seq(from = CVrange[1], to = CVrange[2], by = CVrange[3])
    nc <- length(l.c)
    cvec <- c()
    
    for (i in 1:nc){
      tryCatch({
        #loop through values and filter
        ps.wsm <- phyloseq::filter_taxa(ps.wsm, function(x) sd(x)/mean(x) > l.c[i], TRUE)
        cvec[i] <- phyloseq::ntaxa(ps.wsm)
        
      },
      error=function(e){cat("Warning :c",conditionMessage(e), "\n")})
    }
    #create df
    #make both vectors same length and add NAs if CV filter zeroed out ASV table
    length(cvec) <- length(l.c)
    dfc <- as.data.frame(cbind(l.c, cvec))
    colnames(dfc) <- c("CV.filter", "ASV.count")
    rownames(dfc) <- seq(1:length(l.c))
  }
  
  dfc
}

getRA <- function(ps, WST=NULL, RArange){
  
  #WS filtering
  if(is.null(WST)){
    message('Not applying WS filter')
    ps.ws <- ps
  } else {
    ps.ws <- WSfilter(ps = ps, WST = WST)
  }
  
  #build param vectors
  if(is.null(RArange)){
    dfr <- NULL
  } else {
    l.r <- seq(from = RArange[1], to = RArange[2], by = RArange[3])
    nr <- length(l.r)
    rvec <- c()
    
    for (i in 1:nr){
      tryCatch({
        #loop through values and filter
        raf <- sum(phyloseq::taxa_sums(ps.ws)) * l.r[i]
        ps.ws <- phyloseq::prune_taxa(taxa_sums(ps.ws)>=raf, ps.ws)
        rvec[i] <- phyloseq::ntaxa(ps.ws)
        
      },
      error=function(e){cat("Warning :r",conditionMessage(e), "\n")})
    }
    #create df
    #make both vectors same length and add NAs if RF filter zeroed out ASV table
    length(rvec) <- length(l.r)
    dfr <- as.data.frame(cbind(l.r, rvec))
    colnames(dfr) <- c("relative.abundance.filter", "ASV.count")
    rownames(dfr) <- seq(1:length(l.r))
  }
  
  dfr
}

getPrev <- function(ps, WST=NULL, Prange){
  
  #WS filtering
  if(is.null(WST)){
    message('Not applying WS filter')
    ps.ws <- ps
  } else {
    ps.ws <- WSfilter(ps = ps, WST = WST)
  }
  
  asv.tab <- format.ASV.tab(ps.ws)
  
  #build param vectors
  l.p <- seq(from = Prange[1], to = Prange[2], by = Prange[3])
  np <- length(l.p)
  pvec <- c()
  taxa.cvec <- c()
  
  #get prevalence list for each taxon
  taxa.plist <- apply(X = asv.tab, MARGIN = 1, FUN = function(x){names(x)[which(x!=0)]})
  #populate vector of sample counts per ASV
  for(j in 1:length(taxa.plist)){
    taxa.cvec[j] <- length(taxa.plist[[j]])
  }
  
  #loop through params
  for (i in 1:np){
    tryCatch({
      #apply ASV names and filter ASVs below PF
      names(taxa.cvec) <- names(taxa.plist)
      prev.count <- phyloseq::nsamples(ps.ws)* l.p[i]
      taxa.cvec.f <- taxa.cvec[which(taxa.cvec > prev.count)]
      tn.cvec.f <- names(taxa.cvec.f)
      #filter ps
      ps.ws <- phyloseq::prune_taxa(tn.cvec.f, ps.ws)
      pvec[i] <- phyloseq::ntaxa(ps.ws)
      
    },
    error=function(e){cat("Warning :p",conditionMessage(e), "\n")})
  }
  
  #create df
  #make both vectors same length and add NAs if PF filter zeroed out ASV table
  length(pvec) <- length(l.p)
  dfp <- cbind.data.frame(l.p, pvec)
  colnames(dfp) <- c("prevalence.filter", "ASV.count")
  rownames(dfp) <- seq(1:length(l.p))
  #name taxa prevalence vector
  names(taxa.cvec) <- names(taxa.plist)
  
  # Build return list
  l.return = list()
  l.return[['prevalence.filtering.stats']] <- dfp
  l.return[['ASV.prevalence.count']] <- taxa.cvec
  
  return(l.return)
  
}

#filtering scripts
WSfilter <- function(ps, WST){
  
  #perform filter
  message('Applying WS filter threshold of ', WST)
  
  filterfx = function(x){
    x[(x / sum(x)) < WST] <- 0
    return(x)
  }
  
  ps <- phyloseq::transform_sample_counts(ps, fun = filterfx)
  ps
}

MDfilter <- function(ps, mdFACTOR, mdCAT, mdNEGATIVE=FALSE){
  #create sample df for subsetting
  sampledf <- suppressWarnings(as.matrix(phyloseq::sample_data(ps)))
  
  if (isTRUE(mdNEGATIVE)){
    filtered.names <- rownames(sampledf[which(sampledf[,match(mdCAT, colnames(sampledf))] == mdFACTOR),])
    message('Removing ',  (phyloseq::nsamples(ps) - length(filtered.names)), ' samples not matching metadata identifiers ', mdCAT, ":", mdFACTOR)
  } else {
    filtered.names <- rownames(sampledf[which(sampledf[,match(mdCAT, colnames(sampledf))] != mdFACTOR),])
    message('Removing ',  (phyloseq::nsamples(ps) - length(filtered.names)), ' samples matching metadata identifiers ', mdCAT, ":", mdFACTOR)
  }    
  
  #subset sampledf to include nonfiltered samples only
  sampledf.s <- as.data.frame(sampledf[filtered.names,])
  phyloseq::sample_data(ps) <- phyloseq::sample_data(sampledf.s)
  ps
}

CVfilter <- function(ps, WST=NULL, CVF){
  
  #WS filtering
  if(is.null(WST)){
    message('Not applying WS filter')
    ps.ws <- ps
  } else {
    ps.ws <- WSfilter(ps = ps, WST = WST)
  }
  
  #standardize to median sample depth
  ps.wsm <- standardize.median(ps.ws)
  
  #perform filter
  ps.wsm <- phyloseq::filter_taxa(ps.wsm, function(x) sd(x)/mean(x) > CVF, TRUE)
  #get taxa names to apply to original, unstandardized dataset
  filtered.taxa.names <- phyloseq::taxa_names(ps.wsm)
  #apply filter to unstandardized dataset
  ps.ws <- phyloseq::prune_taxa(taxa = filtered.taxa.names, x = ps.ws)
  ps.ws
  
}


RAfilter<- function(ps, WST=NULL, RAF){
  
  #WS filtering
  if(is.null(WST)){
    message('Not applying WS filter')
    ps.ws <- ps
  } else {
    ps.ws <- WSfilter(ps = ps, WST = WST)
  }
  
  #perform filter
  raf <- sum(phyloseq::taxa_sums(ps.ws)) * RAF
  ps.ws <- phyloseq::prune_taxa(taxa_sums(ps.ws)>=raf, ps.ws)
  ps.ws
  
}

Pfilter <- function(ps, WST=NULL, PF){
  
  #WS filtering
  if(is.null(WST)){
    message('Not applying WS filter')
    ps.ws <- ps
  } else {
    ps.ws <- WSfilter(ps = ps, WST = WST)
  }
  
  #format asv table
  asv.tab <- format.ASV.tab(ps.ws)
  
  #create sample count vector
  taxa.cvec <- c()
  #get prevalence list for each taxon
  taxa.plist <- apply(X = asv.tab, MARGIN = 1, FUN = function(x){names(x)[which(x!=0)]})
  #populate vector of sample counts per ASV
  for(j in 1:length(taxa.plist)){
    taxa.cvec[j] <- length(taxa.plist[[j]])
  }
  names(taxa.cvec) <- names(taxa.plist)
  prev.count <- phyloseq::nsamples(ps.ws)* PF
  taxa.cvec.f <- taxa.cvec[which(taxa.cvec > prev.count)]
  tn.cvec.f <- names(taxa.cvec.f)
  #perform filter
  ps.ws <- phyloseq::prune_taxa(tn.cvec.f, ps.ws)
  ps.ws
  
}

#WRAPPER FUNCTIONS
estimate.WSthreshold <- function(ps, WSrange, controlID, controlFASTA=NULL, useREFSEQ=FALSE) {
  
  #throw error if controlID doesn't match
  if(!(controlID %in% phyloseq::sample_names(ps))){
    stop("controlID provided is not a valid sample name")
  }
  
  #convert param string to numeric vector
  string.w <- substitute(WSrange)
  WST <- eval(expr = format.parameter.string(string = string.w), envir = parent.frame())
  message('Estimating filtering statistics from WS thresholds ', WST[1], ' to ', WST[2], ' by ', WST[3])
  gws <- getWS(ps = ps, WSrange = WST, controlID = controlID, controlFASTA = controlFASTA, useREFSEQ=useREFSEQ)
  gws
  
}



estimate.ASthreshold <- function(ps, WST=NULL, RAT=NULL, CVT=NULL, PFT=NULL, mdCAT=NULL, mdFACTOR=NULL, mdNEGATIVE=FALSE,
                                 minLIB=NULL, Prange=NULL, CVrange=NULL, RArange=NULL){
  
  #throw error if mdCAT doesn't match
  if(all(!is.null(mdCAT), !(mdCAT %in% colnames(phyloseq::sample_data(ps))))){
    stop("mdCAT provided is not a valid metadata category")
  }
  
  #remove samples < minlib
  if(is.null(minLIB)){
    ps = ps
  } else {
    pml.c <- nrow(phyloseq::sample_data(ps))
    ps = phyloseq::prune_samples(phyloseq::sample_sums(ps)>=minLIB, ps)
    message('Removing ',(pml.c -  phyloseq::nsamples(ps)), ' samples with read count < ', minLIB)
  }
  
  #WS filtering
  if (is.null(WST)){
    ps.ws <- ps
  } else {
    ps.ws <- WSfilter(ps = ps, WST = WST)
  }
  
  #save WS filtered object for reversion later
  ps.wso <- ps.ws
  
  #METADATA BASED SAMPLE FILTERING
  if (any(c(is.null(mdCAT), is.null(mdFACTOR)))){
    ps.ws <- ps.ws
  } else {
    ps.ws <- MDfilter(ps = ps.ws, mdFACTOR = mdFACTOR, mdCAT = mdCAT, mdNEGATIVE = mdNEGATIVE)
  }
  
  #INCORPORATE FIXED THRESHOLDS
  #RELATIVE ABUNDANCE
  if(!is.null(RAT)){
    ps.ws <- suppressMessages(RAfilter(ps = ps.ws, WST = NULL, RAF = RAT))
    message('Applying fixed relative abundance threshold of ', RAT)
  }
  #CV
  if(!is.null(CVT)){
    ps.ws <- suppressMessages(CVfilter(ps = ps.ws, WST = NULL, CVF = CVT))
    message('Applying fixed CV threshold of ', CVT)
  }
  #PREVALENCE
  if(!is.null(PFT)){
    ps.ws <- suppressMessages(Pfilter(ps = ps.ws, WST = NULL, PF = PFT))
    message('Applying fixed prevalence threshold of ', PFT)
  }
  
  #ESTIMATION
  #RELATIVE ABUNDANCE
  #build param lists
  if(is.null(RArange)){
    gr <- NULL
  } else {
    #convert param string to numeric vector
    string.r <- substitute(RArange)
    RAF <- eval(expr = format.parameter.string(string = string.r), envir = parent.frame())
    message('Estimating filtering statistics from relative abundance thresholds ', RAF[1], ' to ', RAF[2], ' by ', RAF[3])
    gr <- suppressMessages(getRA(ps = ps.ws, WST = NULL, RArange = RAF))
    
  }
  
  #CV
  #build param lists
  if(is.null(CVrange)){
    gc <- NULL
  } else {
    string.c <- substitute(CVrange)
    CVF <- eval(expr = format.parameter.string(string = string.c), envir = parent.frame())
    message('Estimating filtering statistics from CV thresholds ', CVF[1], ' to ', CVF[2], ' by ', CVF[3])
    gc <- suppressMessages(getCV(ps = ps.ws, WST = NULL, CVrange = CVF))
  }
  
  #PREVALENCE
  #Build param lists
  if(is.null(Prange)){
    gp <- NULL
  } else {
    string.p <- substitute(Prange)
    PF <- eval(expr = format.parameter.string(string = string.p), envir = parent.frame())
    message('Estimating filtering statistics from prevalence thresholds ', PF[1], ' to ', PF[2], ' by ', PF[3])
    gp <- suppressMessages(getPrev(ps = ps.ws, WST = NULL, Prange = PF))
  }
  
  #CREATE ASV DF
  #build df vectors
  ts <- taxa_sums(ps.wso)
  tsp <- taxa_sums(ps.wso)/sum(taxa_sums(ps.wso)) * 100
  namevec <- names(ts)
  #standardize to median sample depth for CV calculation
  ps.ws <- standardize.median(ps.wso)
  asv.tab <- format.ASV.tab(ps.ws)
  cv.asv <- apply(asv.tab[namevec,], MARGIN = 1, FUN = function(x) sd(x)/mean(x))
  tax.tab <- phyloseq::tax_table(ps.wso)[namevec,]
  
  #set prev vectors to null if no prev stats desired
  if (all(c(is.null(Prange), !is.null(PFT)))){
    gp.reload <- suppressMessages(getPrev(ps = ps.ws, WST = NULL, Prange = c(0.10,0.11,0.01)))
    taxa.cvec <- gp.reload$ASV.prevalence.count
    prev <- taxa.cvec[namevec]
    prevp <- prev/phyloseq::nsamples(ps.ws) * 100
  } else if (all(c(is.null(Prange), is.null(PFT)))){
    prev <- rep(NA, length(ts))
    prevp <- rep(NA, length(ts))
  } else {
    gp.reload <- suppressMessages(getPrev(ps = ps.ws, WST = NULL, Prange = PF))
    taxa.cvec <- gp.reload$ASV.prevalence.count
    prev <- taxa.cvec[namevec]
    prevp <- prev/phyloseq::nsamples(ps.ws) * 100
  }
  
  #build df and rename
  df.asv <- cbind.data.frame(ts, tsp, prev, prevp, cv.asv, tax.tab, rownames(tax.tab))
  colnames(df.asv)[1:5] <- c("ASV.read.count", "ASV.read.percent", "ASV.prevalence", "ASV.prevalence.percent", "ASV.CV")
  colnames(df.asv)[ncol(df.asv)] <- "ASV.ID"
  rownames(df.asv) <- seq(1:nrow(df.asv))
  
  # Build return list
  l.return = list()
  l.return[['relative.abundance.filtering.stats']] <- gr
  l.return[['CV.filtering.stats']] <- gc
  l.return[['prevalence.filtering.stats']] <- gp$prevalence.filtering.stats
  l.return[['ASV.filtering.stats']] <- df.asv
  
  return(l.return)
}

microfilter <- function(ps, controlID=NULL, mdCAT=NULL, mdFACTOR=NULL, mdNEGATIVE=FALSE, minLIB=NULL, WST=NULL, RAT=NULL, CVT=NULL, PFT=NULL, return.all=FALSE){
  
  #throw error if controlID doesn't match
  if(all(!is.null(controlID), !(controlID %in% phyloseq::sample_names(ps)))){
    stop("controlID provided is not a valid sample name")
  }
  
  #throw error if mdCAT doesn't match
  if(all(!is.null(mdCAT), !(mdCAT %in% colnames(phyloseq::sample_data(ps))))){
    stop("mdCAT provided is not a valid metadata category")
  }
  
  #remove samples < minlib
  if(is.null(minLIB)){
    ps = ps
  } else {
    pml.c <- nrow(phyloseq::sample_data(ps))
    ps = phyloseq::prune_samples(phyloseq::sample_sums(ps)>=minLIB, ps)
    message('Removing ',(pml.c -  phyloseq::nsamples(ps)), ' samples with read count < ', minLIB)
  }
  
  #create unfiltered sample sum vector
  ov <- phyloseq::sample_sums(ps)
  
  #WS filtering
  if (is.null(WST)){
    ps.ws <- ps
  } else {
    ps.ws <- WSfilter(ps = ps, WST = WST)
  }
  
  #create WS filtered sample sum vector
  ifv <- phyloseq::sample_sums(ps.ws)
  #calculate percent filtered, individual
  p.if <- phyloseq::sample_sums(ps.ws)/phyloseq::sample_sums(ps)*100
  
  asv.tab <- format.ASV.tab(ps.ws)
  
  #METADATA-BASED SAMPLE REMOVAL
  if(is.null(controlID)){
    npos <- NULL
    tax.tab.subset <- NULL
    ttsn <- NULL
  } else {
    #calculate control taxa count
    npos <- nrow(asv.tab[which(asv.tab[,match(controlID, colnames(asv.tab))] != 0),])
    
    #get taxonomy of taxa in positive control
    tax.tab <- phyloseq::tax_table(ps.ws)
    taxanames.control <- rownames(asv.tab[which(asv.tab[,match(controlID, colnames(asv.tab))] != 0),])
    tax.tab.subset <- tax.tab[taxanames.control] #taxonomy of taxa in positive control
    ttsn <- tax.tab.subset
    rownames(ttsn) <- NULL
  }
  
  #remove samples by metadata filters
  if (any(c(is.null(mdCAT), is.null(mdFACTOR)))){
    ps.ws <- ps.ws
  } else {
    ps.ws <- MDfilter(ps = ps.ws, mdFACTOR = mdFACTOR, mdCAT = mdCAT, mdNEGATIVE = mdNEGATIVE)
  }
  
  #AS filtering
  #relative abundance filter
  if(is.null(RAT)){
    ps.ws <- ps.ws
    raf <- NULL
  } else {
    message('Applying relative abundance threshold of ', RAT)
    ps.ws <- suppressMessages(RAfilter(ps = ps.ws, WST = NULL, RAF = RAT))
    raf <- RAT * sum(phyloseq::taxa_sums(ps.ws))
  }
  
  #CV filter
  if(is.null(CVT)){
    ps.ws <- ps.ws
  } else {
    message('Applying CV threshold of ', CVT)
    ps.ws <- suppressMessages(CVfilter(ps = ps.ws, WST = NULL, CVF = CVT))
  }
  
  #prevalence filter
  if(is.null(PFT)){
    ps.ws <- ps.ws
    prev.count <- NULL
  } else {
    message('Applying prevalence threshold of ', PFT)
    ps.ws <- suppressMessages(Pfilter(ps = ps.ws, WST = NULL, PF = PFT))
    prev.count <- phyloseq::nsamples(ps.ws) * PFT
  }
  
  #create AS filter sample sum vector
  pfv <- phyloseq::sample_sums(ps.ws)
  #calculate percent filtered, AS
  p.pf <- suppressWarnings(phyloseq::sample_sums(ps.ws)/phyloseq::sample_sums(ps)[names(phyloseq::sample_sums(ps.ws))]*100)
  
  #order vectors
  pfv <- pfv[names(p.if)]
  p.pf <- p.pf[names(p.if)]
  
  #cbind vectors into df
  sstab <- cbind(ov, ifv, p.if, pfv, p.pf)
  colnames(sstab) <- c("unfiltered.read.count", "WSfiltered.read.count", "WSfiltered.read.percent", "ASfiltered.read.count", "ASfiltered.read.percent")
  
  # Build return list
  l.return = list()
  if (return.all==FALSE){
    return(ps.ws)
  } else {
    l.return[['filtered.phyloseq']] <- ps.ws
    l.return[['ntaxa.in.control']] <- npos
    l.return[['control.taxa.sequences']] <- rownames(tax.tab.subset)
    l.return[['taxonomy.of.control.taxa']] <- ttsn
    l.return[['read.count.table']] <- sstab
    l.return[['relative.abundance.filter.read.count']] <- raf
    l.return[['prevalence.filter.sample.count']] <- prev.count
    
  }
  
  return(l.return)
}

write.dataset.biom <- function(ps, filePATH, filePREFIX, writeFASTA=TRUE, rename=FALSE, useREFSEQ=FALSE){
  
  #pull seqs from refseq slot or extract from ASV ID for fasta format
  if (isTRUE(useREFSEQ)){
    #from phyloseq refseq slot
    f.onames <- phyloseq::refseq(ps)
  } else {
    f.onames <- phyloseq::taxa_names(ps)
  }
  
  if (isTRUE(rename)){
    phyloseq::taxa_names(ps) <- paste("ASV", 1:length(phyloseq::taxa_names(ps)), sep = "")
    names(f.onames) <- paste0(">", phyloseq::taxa_names(ps))
  } else {
    names(f.onames) <- paste0(">", phyloseq::taxa_names(ps))
  }
  
  #generate biom file
  suppressWarnings(ps.b <- biomformat::make_biom(
    data = format.ASV.tab(ps),
    sample_metadata = as.data.frame(phyloseq::sample_data(ps)),
    observation_metadata = as.data.frame(phyloseq::tax_table(ps)), 
    matrix_element_type = "int"
  )
  )
  
  #create output string
  if (isTRUE(writeFASTA)){
    fa <- print(paste0(filePATH, filePREFIX, "_ASVs.fasta"))
  }
  bo <- print(paste0(filePATH, filePREFIX, "_ASV_table.biom"))
  
  #write output
  if (isTRUE(writeFASTA)){
    write.table(x = f.onames, file = fa, quote = FALSE, sep = "\n", col.names = FALSE)
  }
  #biom export
  biomformat::write_biom(x = ps.b, biom_file = bo)
  
  #return phyloseq object with taxa renamed to ASV1, etc., if desired
  if (isTRUE(rename)){
    return(ps)
  }
}

write.dataset <- function(ps, filePATH, filePREFIX, writeFASTA=TRUE, rename=FALSE, useREFSEQ=FALSE){
  
  #pull seqs from refseq slot or extract from ASV ID for fasta format
  if (isTRUE(useREFSEQ)){
    #from phyloseq refseq slot
    f.onames <- phyloseq::refseq(ps)
  } else {
    f.onames <- phyloseq::taxa_names(ps)
  }
  
  if (isTRUE(rename)){
    phyloseq::taxa_names(ps) <- paste("ASV", 1:length(phyloseq::taxa_names(ps)), sep = "")
    names(f.onames) <- paste0(">", phyloseq::taxa_names(ps))
  } else {
    names(f.onames) <- paste0(">", phyloseq::taxa_names(ps))
  }
  
  
  #generate asv table formatted for biom generation
  asv.tab <- format.ASV.tab(ps)
  suppressWarnings(asv.tab <- as.matrix(asv.tab))
  cb <- as.matrix(cbind(rownames(asv.tab), asv.tab))
  rcb <- as.matrix(rbind(colnames(cb), cb))
  rcb[1,1] <- "#ASVID"
  rownames(rcb) <- NULL
  colnames(rcb) <- NULL
  
  #generate tax table formatted for biom generation
  tax.tab <- as.data.frame(phyloseq::tax_table(ps))
  tax.tab$taxonomy <- tidyr::unite_(tax.tab, "out", c(colnames(tax.tab)), sep = ";")
  cbt <- as.matrix(cbind(rownames(tax.tab), tax.tab$taxonomy))
  rcbt <- as.matrix(rbind(c("#ASVID", "taxonomy"), cbt))
  rownames(cbt) <- NULL
  colnames(cbt) <- NULL
  
  #generate sampledf table formatted for biom generation
  samdf <- suppressWarnings(as.matrix(phyloseq::sample_data(ps)))
  cbs <- as.matrix(cbind(rownames(samdf), samdf))
  rcbs <- as.matrix(rbind(colnames(cbs), cbs))
  rcbs[1,1] <- "#SampleID"
  rownames(rcbs) <- NULL
  colnames(rcbs) <- NULL
  
  #create output string
  if (isTRUE(writeFASTA)){
    fa <- print(paste0(filePATH, filePREFIX, "_ASVs.fasta"))
  }
  otb <- print(paste0(filePATH, filePREFIX, "_ASV_table.txt"))
  ttb <- print(paste0(filePATH, filePREFIX, "_ASV_taxonomy.txt"))
  stb <- print(paste0(filePATH, filePREFIX, "_sample_data.txt"))
  
  
  #write output
  #ASV fasta 
  if (isTRUE(writeFASTA)){
    write.table(x = f.onames, file = fa, quote = FALSE, sep = "\n", col.names = FALSE)
  }
  #asv.tab
  write.table(x = rcb, file = otb, row.names = FALSE, col.names = FALSE, quote = FALSE, sep = "\t")
  #tax.tab
  write.table(x = rcbt, file = ttb, row.names = FALSE, col.names = FALSE, quote = FALSE, sep = "\t")
  #sampledf
  write.table(x = rcbs, file = stb, row.names = FALSE, col.names = FALSE, quote = FALSE, sep = "\t")
  
  #return phyloseq object with taxa renamed to ASV1, etc., if desired
  if (isTRUE(rename)){
    return(ps)
  }
}