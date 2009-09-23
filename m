From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 23 Sep 2009 19:38:35 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2-devel: remove an invalid single
 quotation marks from the mlog string in dlm_unregister_domain()
In-Reply-To: <1253697004-23982-1-git-send-email-jeff.liu@oracle.com>
References: <> <1253697004-23982-1-git-send-email-jeff.liu@oracle.com>
Message-ID: <4ABA08BB.9010601@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jeff,

Jeff Liu wrote:
>   "Following lockres' are still on the "
>                     ^ here
> 

I guess "lockres'" means there could be more than one lockres there.
