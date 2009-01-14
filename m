From: tristan.ye <tristan.ye@oracle.com>
Date: Wed, 14 Jan 2009 13:48:59 +0800
Subject: [Ocfs2-devel] [PATCH 0/5] OCFS2 quota fixes
In-Reply-To: <1231798833-6850-1-git-send-email-jack@suse.cz>
References: <y>  <1231798833-6850-1-git-send-email-jack@suse.cz>
Message-ID: <1231912139.6716.7.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 2009-01-12 at 23:20 +0100, Jan Kara wrote:
> Hello,
> 
> the following series of patches fixes some issues with OCFS2 quotas.
> The first patch modifies VFS quota locking, the next patch uses the
> fact to simplify OCFS2 quota locking and solves a few deadlock issues.

Seems this series of patches did not fix the deadlock issue completely,
they do resolve the bug 1043, but still did not fix bug 1067, and it
even brought us a new regression bug,see my comments in bug 1043,1067
and in your 5th patch:-)

Thanks,

Tristan

> The third and the fourth patches fix another possible deadlocks in OCFS2
> quota code and the last patch is a minor cleanup.
> 
> 								Honza
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
