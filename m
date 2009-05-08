From: Coly Li <coly.li@suse.de>
Date: Fri, 08 May 2009 14:03:21 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2_cluster_lock: code cleanup for
 redundant assignment
In-Reply-To: <4A032D7D.5040600@oracle.com>
References: <4A0328DC.6050702@suse.de> <4A032D7D.5040600@oracle.com>
Message-ID: <4A03CB29.1000807@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> While this patch may be correct, we have to take into consideration
> that we have to backport patches to 1.4, etc. In that light, is this
> patch worth it?
> 

When I check dlm related code in ocfs2, this line makes me uncomfortable, after
sending out the patch, I feel better :))

I understand the comments from you and Jeol, and partially agree with you all :)
Thanks for the response.

-- 
Coly Li
SuSE Labs
