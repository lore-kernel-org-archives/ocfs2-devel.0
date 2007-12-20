From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Dec 20 17:16:28 2007
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Local alloc window size
	changeable via mount option
In-Reply-To: <1198191491-14441-2-git-send-email-sunil.mushran@oracle.com>
References: <1198191491-14441-1-git-send-email-sunil.mushran@oracle.com>
	<1198191491-14441-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221011507.GD8203@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 02:58:11PM -0800, Sunil Mushran wrote:
>  static inline int ocfs2_local_alloc_window_bits(struct ocfs2_super *osb)
>  {
> -	BUG_ON(osb->s_clustersize_bits < 12);
> +	BUG_ON(osb->s_clustersize_bits > 20);
>  
> -	return 2048 >> (osb->s_clustersize_bits - 12);
> +	return osb->local_alloc_size << (20 - osb->s_clustersize_bits);
>  }

	Can we document the magic bit numbers somehow?  I don't think we
need super-awesome defines or anything, just "20 is 1MB, we're
calculating local_alloc_size in MB" or something like that.
 
Joel

-- 

"I always thought the hardest questions were those I could not answer.
 Now I know they are the ones I can never ask."
			- Charlie Watkins

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
