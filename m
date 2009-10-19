From: Tristan <tristan.ye@oracle.com>
Date: Mon, 19 Oct 2009 15:06:43 +0800
Subject: [Ocfs2-devel] [PATCH 0/5] Quota support for disabling
 inline-data feature (v2) and a fix
In-Reply-To: <1255543739-23844-1-git-send-email-jack@suse.cz>
References: <1255543739-23844-1-git-send-email-jack@suse.cz>
Message-ID: <4ADC1003.9080102@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jan,

Other than an error I've pointed out in patch 4, this patch series can 
be very much alive from my quota-tools-test.

Tested-By Tristan.


Jan Kara wrote:
>   Hi,
>
>   here is a new version of the patch to implement quota support for disabling
> inline-data feature. Now, main functions for changing quotas are implemented
> in libocfs2 as Joel asked and used from tunefs.ocfs2. Disabling of sparse
> feature is changed to use these functions as well.
>   Finally, the series contains a fix to not load quota information from disk
> when it's already in memory (happens when tunefs is asked to do several
> operations at once) and a rebased patch to do not account for space used
> by sparse system files when disabling sparse feature.
>
> 								Honza
>   
