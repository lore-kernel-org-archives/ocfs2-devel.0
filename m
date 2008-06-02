From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 2 Jun 2008 16:07:21 -0700
Subject: [Ocfs2-devel] [RFC][PATCH 4/4] configfs: Make multiple
	default_group	destructions lockdep friendly
In-Reply-To: <4836F48A.70008@kerlabs.com>
References: <20080522114048.265996107@kerlabs.com>
	<20080522114947.927196541@kerlabs.com> <4836F48A.70008@kerlabs.com>
Message-ID: <20080602230721.GD19500@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

	A couple comments.
	First, put a BUG_ON() where you have BAD BAD BAD - we shouldn't
be creating a depth we can't delete.

> @@ -392,6 +437,10 @@ static int configfs_detach_prep(struct d
>  			 * deep nesting of default_groups
>  			 */
>  			ret = configfs_detach_prep(sd->s_dentry);
> +			/* Update parent's lock_level so that remaining
> +			 * sibling children keep on globally increasing
> +			 * lock_level */
> +			copy_dirent_lock_level(sd, parent_sd);
>  			if (!ret)
>  				continue;
>  		} else

	I'm not sure I get this hunk.  If our parent was 1 and we are 2,
we are copying 2 to our parent so the parent can only have other
children at 3?

Joel

-- 

Life's Little Instruction Book #267

	"Lie on your back and look at the stars."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
