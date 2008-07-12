From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 11 Jul 2008 18:24:35 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix race between mount
	and	recovery
In-Reply-To: <1215822318-6442-3-git-send-email-sunil.mushran@oracle.com>
References: <1215822318-6442-1-git-send-email-sunil.mushran@oracle.com>
	<1215822318-6442-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080712012435.GI22577@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 11, 2008 at 05:25:18PM -0700, Sunil Mushran wrote:
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 52f02fe..7faab59 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -132,6 +132,16 @@ static inline void ocfs2_inode_set_new(struct ocfs2_super *osb,
>  	spin_unlock(&trans_inc_lock);
>  }
>  
> +static inline void ocfs2_bump_recovery_generation(struct ocfs2_dinode *di)
> +{
> +	le32_add_cpu(&(di->id1.journal1.ij_recovery_generation), 1);
> +}
> +
> +static inline u32 ocfs2_get_recovery_generation(struct ocfs2_dinode *di)
> +{
> +	return le32_to_cpu(di->id1.journal1.ij_recovery_generation);
> +}

	There's no reason for these to be inline or even outside of
journal.c.

Joel

-- 

"Practice random acts of kindness and senseless acts of beauty."

 Oh, and don't forget where your towel is.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
