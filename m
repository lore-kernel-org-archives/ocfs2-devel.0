From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 14 Jul 2010 13:24:55 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: don't overwrite error codes in
 ocfs2_init_acl
In-Reply-To: <4C3D8D53.7010400@oracle.com>
References: <4C3D8D53.7010400@oracle.com>
Message-ID: <4C3E1D17.1080502@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tiger,

Please can you add Reported-by to the patch.

Appears the issue was caused by commit 
fcefd25ac89239cb57fa198f125a79ff85468c75.
fcefd25ac89239cb57fa198f125a79ff85468c75 tags/v2.6.34-rc3~5^2~7

Also add that the patch needs to be backported to 2.6.34. cc 
stable at kernel.org
the patch.

Sunil

On 07/14/2010 03:11 AM, Tiger Yang wrote:
> Hi, all,
>
> Pawel(pzlist at mp.pl) reported a bug in ocfs2 acl. This patch fix this 
> issue.
>
> Thanks,
> tiger
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100714/f7d178ab/attachment.html 
