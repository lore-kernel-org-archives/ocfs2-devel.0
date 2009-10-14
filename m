From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 14 Oct 2009 13:04:53 -0700
Subject: [Ocfs2-devel] [PATCH 0/5] Quota support for disabling
 inline-data feature (v2) and a fix
In-Reply-To: <1255543739-23844-1-git-send-email-jack@suse.cz>
References: <1255543739-23844-1-git-send-email-jack@suse.cz>
Message-ID: <20091014200453.GD4530@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Oct 14, 2009 at 08:08:54PM +0200, Jan Kara wrote:
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

Any chance you can resend these to ocfs2-tools-devel?  I just want to
make sure folks involved in tools work get to see them.

Thanks!
Joel

-- 

"Same dancers in the same old shoes.
 You get too careful with the steps you choose.
 You don't care about winning but you don't want to lose
 After the thrill is gone."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
