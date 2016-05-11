From: Gang He <ghe@suse.com>
Date: Tue, 10 May 2016 19:58:52 -0600
Subject: [Ocfs2-devel] [PATCH 0/5] ocfs2: sysfs and cleanup
In-Reply-To: <1462902759-27084-1-git-send-email-rgoldwyn@suse.de>
References: <1462902759-27084-1-git-send-email-rgoldwyn@suse.de>
Message-ID: <5733025C020000F9000364A5@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Goldwyn,

Thank for your efforts on improving online file check.
I was being engaged by some bugs in the past days.

Thanks
Gang


>>> 
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> This adds /sys/fs/ocfs2/<s_id> to the sys filesystem. All other
> files are added in this directory. This is done by:
> 1. Adding kobject in the ocfs2_super structure
> 2. Using ocfs2_sb_attr which encompass all the show() and store() functions
> 
> This also reduce code and does away with unnecessary data structure,
> but adds some in the ocfs2_super for house keeping.
> 
> Hopefully, this would be used to further add configurable parameters
> for the super block.
> 
> Suggestions/Criticism welcome.
> 
> -- 
> Goldwyn
