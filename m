From: Gang He <ghe@suse.com>
Date: Mon, 21 Mar 2016 20:28:20 -0600
Subject: [Ocfs2-devel] HEADUP: generic FICLONE ioctl and
 ->clone_file_range method
In-Reply-To: <20160321154259.GA14392@lst.de>
References: <20160321154259.GA14392@lst.de>
Message-ID: <56F11E44020000F90002EAF5@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Christoph,

The feature sounds good. OCFS2 has file clone feature (so far, we only support clone the whole file), 
what efforts will be involved if we add this feature support?



Thanks
Gang


>>> 
> We made the btrfs clone support generic to add NFS support, and support
> the future XFS reflink support.  It looks like ocfs2 could support
> these as well, so it would be great to get the clone_file_range method
> wired up.  xfstests has over 100 testcases for it, so it should be
> easy to verify.
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
