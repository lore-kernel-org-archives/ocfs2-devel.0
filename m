From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 28 Jul 2009 16:05:09 -0700
Subject: [Ocfs2-devel] [PATCH 5/8] Quota support for fsck.ocfs2
In-Reply-To: <1248717216-26617-6-git-send-email-jack@suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
	<1248717216-26617-6-git-send-email-jack@suse.cz>
Message-ID: <20090728230509.GC20595@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 27, 2009 at 07:53:33PM +0200, Jan Kara wrote:
> diff --git a/fsck.ocfs2/include/pass5.h b/fsck.ocfs2/include/pass5.h
> new file mode 100644
> index 0000000..dfd27cd
> --- /dev/null
> +++ b/fsck.ocfs2/include/pass5.h
> @@ -0,0 +1,32 @@
> +/*
> + * pass5.h
> + *
> + * Copyright (C) 2009 Novell Corporation.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License as published by the Free Software Foundation; either
> + * version 2 of the License, or (at your option) any later version.

	We generally use GPL version 2 only, but you are welcome to
license this 2-or-later.  I only mention this because...

> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.

	Can you check http://kernel.us.oracle.com/~smushran/license.txt
and update your header?  The last paragraph is no longer recommended by
the FSF, and we'd love for this header to have the emacs/vim lines at
the top.

> + *
> + * Author: Jan Kara
> + */

	Also, we deliberately drop author attribution from individual
source files.  You can add yourself to MAINTAINERS.

> +errcode_t o2fsck_pass5(o2fsck_state *ost)
> +{
> +	errcode_t ret;
> +	ocfs2_filesys *fs = ost->ost_fs;
> +	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
> +	int has_usrquota, has_grpquota;
> +
> +	has_usrquota = OCFS2_HAS_RO_COMPAT_FEATURE(super,
> +				OCFS2_FEATURE_RO_COMPAT_USRQUOTA);
> +	has_grpquota = OCFS2_HAS_RO_COMPAT_FEATURE(super,
> +				OCFS2_FEATURE_RO_COMPAT_GRPQUOTA);
> +	/* Nothing to check? */
> +	if (!has_usrquota && !has_grpquota)
> +		return 0;
> +	printf("Pass 5: Checking quota information.\n");
> +	if (has_usrquota) {
> +		ret = ocfs2_new_quota_hash(qhash + USRQUOTA);
> +		if (ret) {
> +			com_err(whoami, ret,
> +				"while allocating user quota hash");
> +			goto out;
> +		}
> +		ret = load_quota_file(ost, USRQUOTA);
> +		if (ret)
> +			goto out;
> +	}
> +	if (has_grpquota) {
> +		ret = ocfs2_new_quota_hash(qhash + GRPQUOTA);
> +		if (ret) {
> +			com_err(whoami, ret,
> +				"while allocating group quota hash");
> +			goto out;
> +		}
> +		ret = load_quota_file(ost, GRPQUOTA);
> +		if (ret)
> +			goto out;
> +	}
> +	ret = ocfs2_compute_quota_usage(fs, qhash[USRQUOTA], qhash[GRPQUOTA]);
> +	if (ret) {
> +		com_err(whoami, ret, "while computing quota usage");
> +		goto out;
> +	}
> +	if (has_usrquota) {
> +		ret = recreate_quota_files(fs, USRQUOTA);
> +		if (ret)
> +			goto out;
> +		ret = ocfs2_free_quota_hash(qhash[USRQUOTA]);
> +		if (ret) {
> +			com_err(whoami, ret, "while release user quota hash");
> +			goto out;
> +		}
> +	}
> +	if (has_grpquota) {
> +		ret = recreate_quota_files(fs, GRPQUOTA);
> +		if (ret)
> +			goto out;
> +		ret = ocfs2_free_quota_hash(qhash[GRPQUOTA]);
> +		if (ret) {
> +			com_err(whoami, ret, "while release group quota hash");
> +			goto out;
> +		}
> +	}

	The way I read this, you check the existing quota structures,
and then ignore them while recomputing the usage.  You just do a full-on
recompute.  Then you write out the newly computed data.  Am I correct?

Joel

-- 

You can use a screwdriver to screw in screws or to clean your ears,
however, the latter needs real skill, determination and a lack of fear
of injuring yourself.  It is much the same with JavaScript.
	- Chris Heilmann

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
