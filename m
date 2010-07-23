From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 23 Jul 2010 18:42:58 -0400
Subject: [Ocfs2-devel] [PATCH V2] Fix the nested PR lock calling issue
In-Reply-To: <4C473BE2.8000608@oracle.com>
References: <20100721144805.GA12822@linux-jjzhang>	<20100721151701.GA3579@laptop.jp.oracle.com>	<20100721160542.GA19036@linux-jjzhang>
	<4C473BE2.8000608@oracle.com>
Message-ID: <4C4A1AF2.7080700@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Sunil,

I think put them in ocfs2_check_acl() is better.
First, check mount option in ocfs2_check_acl()  is more clear than in 
_ocfs2_get_acl().
Second, we already have ocfs2_get_acl and ocfs2_get_acl_nolock, so it 
seems _ocfs2_get_acl is redundant and could cause confusing for reading 
the code.

Regards,
tiger

On 07/21/2010 02:26 PM, Sunil Mushran wrote:
> Why not add _ocfs2_get_acl() that does the same without
> taking the cluster locks?
>    
