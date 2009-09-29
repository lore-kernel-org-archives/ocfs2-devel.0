From: J. Bruce Fields <bfields@fieldses.org>
Date: Tue, 29 Sep 2009 11:31:26 -0400
Subject: [Ocfs2-devel] [NFS] Trouble exporting OCFS2 via NFS
In-Reply-To: <710118.59930.qm@web43139.mail.sp1.yahoo.com>
References: <710118.59930.qm@web43139.mail.sp1.yahoo.com>
Message-ID: <20090929153126.GA388@fieldses.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Sep 28, 2009 at 07:15:40PM +0000, Tim Cullen wrote:
> I've been attempting to export an OCFS2 filesystem via NFS without success. My NFS client mounts the exported filesystem without problem but all subsequent access to the mount point results in Stale NFS File Handle error. On the NFS server in /var/log/messages I see error messages like the ones below complaining about attempts to access beyond the end of the disk.
> 
> I've spoken with a supporting engineer at Oracle who didn't know what the problem might be and suggested I try this list. I'm hoping somebody here might be familiar with this problem.

If I had to guess I would've said it was an ocfs2 problem; maybe
somebody on ocfs2-devel (cc'd) can help?

--b.

> 
> Sep 24 10:52:36 devapp1 kernel: ocfs2: Mounting device (8,3) on (node 2, slot 0)
> with ordered data mode.
> Sep 24 10:53:16 devapp1 kernel: NFSD: Using /var/lib/nfs/v4recovery as the NFSv4
> state recovery directory
> Sep 24 10:53:16 devapp1 kernel: NFSD: starting 90-second grace period
> Sep 24 10:53:32 devapp1 mountd[15182]: authenticated mount request from
> 10.100.0.50:723 for /mnt/rna (/mnt/rna)
> Sep 24 10:53:53 devapp1 kernel: attempt to access beyond end of device
> Sep 24 10:53:53 devapp1 kernel: sda3: rw=0, want=301300545749000, limit=348803280
> Sep 24 10:53:53 devapp1 kernel: (15178,3):ocfs2_read_locked_inode:460 ERROR:
> status = -5
> Sep 24 10:54:11 devapp1 kernel: attempt to access beyond end of device
> Sep 24 10:54:11 devapp1 kernel: sda3: rw=0, want=301334905487368, limit=348803280
> Sep 24 10:54:11 devapp1 kernel: (15178,3):ocfs2_read_locked_inode:460 ERROR:
> status = -5
> Sep 24 10:54:12 devapp1 kernel: attempt to access beyond end of device
> Sep 24 10:54:12 devapp1 kernel: sda3: rw=0, want=301300545749000, limit=348803280
> Sep 24 10:54:12 devapp1 kernel: (15178,3):ocfs2_read_locked_inode:460 ERROR:
> status = -5
> Sep 24 10:54:12 devapp1 kernel: attempt to access beyond end of device
> Sep 24 10:54:12 devapp1 kernel: sda3: rw=0, want=301334905487368, limit=348803280
> Sep 24 10:54:12 devapp1 kernel: (15178,3):ocfs2_read_locked_inode:460 ERROR:
> status = -5
> Sep 24 10:54:15 devapp1 kernel: attempt to access beyond end of device
> Sep 24 10:54:15 devapp1 kernel: sda3: rw=0, want=301334905487368, limit=348803280
> Sep 24 10:54:15 devapp1 kernel: (15178,3):ocfs2_read_locked_inode:460 ERROR:
> status = -5
> Sep 24 10:54:15 devapp1 kernel: attempt to access beyond end of device
> Sep 24 10:54:15 devapp1 kernel: sda3: rw=0, want=301334905487368, limit=348803280
> Sep 24 10:54:15 devapp1 kernel: (15178,3):ocfs2_read_locked_inode:460 ERROR:
> status = -5
> 
> 
> 
>       
> 
> ------------------------------------------------------------------------------
> Come build with us! The BlackBerry&reg; Developer Conference in SF, CA
> is the only developer event you need to attend this year. Jumpstart your
> developing skills, take BlackBerry mobile applications to market and stay 
> ahead of the curve. Join us from November 9&#45;12, 2009. Register now&#33;
> http://p.sf.net/sfu/devconf
> _______________________________________________
> NFS maillist  -  NFS at lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/nfs
> _______________________________________________
> Please note that nfs at lists.sourceforge.net is being discontinued.
> Please subscribe to linux-nfs at vger.kernel.org instead.
>     http://vger.kernel.org/vger-lists.html#linux-nfs
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
