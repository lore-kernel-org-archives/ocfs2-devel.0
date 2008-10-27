From: tristan.ye <tristan.ye@oracle.com>
Date: Mon, 27 Oct 2008 14:55:15 +0800
Subject: [Ocfs2-devel] mkfs patch for creating filesystem with quota
	files
In-Reply-To: <20081024221022.GB10038@duck.suse.cz>
References: <20081024221022.GB10038@duck.suse.cz>
Message-ID: <1225090515.6525.7.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jan,

For tools patch,found something unhappy:(

diff --git a/libocfs2/Makefile b/libocfs2/Makefile
index 446c8b4..18cf2ee 100644
--- a/libocfs2/Makefile
+++ b/libocfs2/Makefile
@@ -72,6 +72,7 @@ CFILES = 		\
 	lockid.c	\
 	backup_super.c	\
 	feature_string.c\
+	quota.c		\
 	image.c
 
Here,you did add a entry for quota.c in libocfs2's Makefile,while the
file you wanna add can not be found through the whole patch.

So after applying the patch on latest ocfs2-tools.git,we can not have it
compiled successfully at all.

I guess you may be forgetting to generate the patch for newly added
quota.c file.


Thanks and regards,

Tristan.



On Sat, 2008-10-25 at 00:10 +0200, Jan Kara wrote:
> Hello,
> 
>   attached is a patch which implements necessary support for
> mkfs so that quota files can be created.
> 							Honza
