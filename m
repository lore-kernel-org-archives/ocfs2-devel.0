From: tristan.ye <tristan.ye@oracle.com>
Date: Tue, 13 Jan 2009 14:01:04 +0800
Subject: [Ocfs2-devel] [PATCH 0/5] OCFS2 quota fixes
In-Reply-To: <1231798833-6850-1-git-send-email-jack@suse.cz>
References: <y> <1231798833-6850-1-git-send-email-jack@suse.cz>
Message-ID: <496C2E20.2040705@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jan Kara wrote:
> Hello,
>
> the following series of patches fixes some issues with OCFS2 quotas.
> The first patch modifies VFS quota locking, the next patch uses the
> fact to simplify OCFS2 quota locking and solves a few deadlock issues.
> The third and the fourth patches fix another possible deadlocks in OCFS2
> quota code and the last patch is a minor cleanup.
>   
Hi Jan,

Would you like to show me the kernel tree/branch where your patches're 
going to be applied?

Btw, I'm also wondering if your latest patches which resolves some 
deadlock issues can also be applicable for bug 1043&1067(deadlock on 
inode removal) on bugzilla:
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1043

At last, It will be greatly appreciated if you can offer me your newly 
released quota-tools for OCFS2. Just simply attach the src tarball in 
replying mail is OK, or let me know the URL where your quota-tools for 
OCFS2 released:-)

Thanks in advance,

Tristan
> 								Honza
>
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
