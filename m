From: Gang He <GHe@suse.com>
Date: Fri, 11 Oct 2019 07:21:35 +0000
Subject: [Ocfs2-devel] Interest in DAX for OCFS2 and/or GFS2?
In-Reply-To: <AT5PR8401MB1025DFAE60F5A5A4BCC5D2038B940@AT5PR8401MB1025.NAMPRD84.PROD.OUTLOOK.COM>
References: <AT5PR8401MB1025DFAE60F5A5A4BCC5D2038B940@AT5PR8401MB1025.NAMPRD84.PROD.OUTLOOK.COM>
Message-ID: <CH2PR18MB3206F78AC614EAC963AF8203CF970@CH2PR18MB3206.namprd18.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello hayes,

> -----Original Message-----
> From: cluster-devel-bounces at redhat.com
> [mailto:cluster-devel-bounces at redhat.com] On Behalf Of Hayes, Bill
> Sent: 2019?10?11? 0:42
> To: ocfs2-devel at oss.oracle.com; cluster-devel at redhat.com
> Cc: Rocky (The good-looking one) Craig <rocky.craig@hpe.com>
> Subject: [Cluster-devel] Interest in DAX for OCFS2 and/or GFS2?
> 
> We have been experimenting with distributed file systems across multiple
> Linux instances connected to a shared block device.  In our setup, the "disk" is
> not a legacy SAN or iSCSI.  Instead it is a shared memory-semantic fabric
> that is being presented as a Linux block device.
> 
> We have been working with both GFS2 and OCFS2 to evaluate the suitability
> to work on our shared memory configuration.  Right now we have gotten
> both GFS2 and OCFS2 to work with block driver but each file system still does
> block copies.  Our goal is to extend mmap() of the file system(s) to allow true
> zero-copy load/store access directly to the memory fabric.  We believe
> adding DAX support into the OCFS2 and/or GFS2 is an expedient path to use a
> block device that fronts our memory fabric with DAX.
> 
> Based on the HW that OCFS2 and GFS2 were built for (iSCSI, FC, DRDB, etc)
> there probably has been no reason to implement DAX to date.  The advent of
> various memory semantic fabrics (Gen-Z, NUMAlink, etc) is driving our
> interest in extending OCFS2 and/or GFS2 to take advantage of DAX.  We
> have two platforms set up, one based on actual hardware and another based
> on VMs and are eager to begin deeper work.
> 
> Has there been any discussion or interest in DAX support in OCFS2?
No, but I think this is very interesting topic/feature.
I hope we can take some efforts in investigating how to make OCFS2 support DAX, since some local file systems have supported this feature for long time.

> Is there interest from the OCFS2 development community to see DAX support
> developed and put upstream?
From my personal view, it is very attractive.
But we also aware cluster file systems are usually based on DLM, DLM usually communicates with each other via the network.
That means network latency should be considered.

Thanks
Gang

> 
> Has there been any discussion or interest in DAX support in GFS2?
> Is there interest from the GFS2 development community to see DAX support
> developed and put upstream?
> 
> Regards,
> Bill
> 
