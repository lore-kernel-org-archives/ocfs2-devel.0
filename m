From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 12 Feb 2014 15:29:21 -0800
Subject: [Ocfs2-devel] [patch 04/11] ocfs2: fix a tiny race when
	running	dirop_fileop_racer
In-Reply-To: <20140124204703.AF70F5A4203@corp2gmr1-2.hot.corp.google.com>
References: <20140124204703.AF70F5A4203@corp2gmr1-2.hot.corp.google.com>
Message-ID: <20140212232921.GZ24361@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> @@ -1097,6 +1174,22 @@ static int ocfs2_rename(struct inode *ol
>  			goto bail;
>  		}
>  		rename_lock = 1;
> +
> +		/* here we cannot guarantee the inodes haven't just been
> +		 * changed, so check if they are nested again */
> +		status = ocfs2_check_if_ancestor(osb, new_dir->i_ino,
> +				old_inode->i_ino);
> +		if (status < 0) {
> +			mlog_errno(status);
> +			goto bail;
> +		} else if (status == 1) {
> +			status = -EPERM;
> +			mlog(ML_ERROR, "src inode %llu should not be ancestor "
> +				"of new dir inode %llu\n",
> +				(unsigned long long)old_inode->i_ino,
> +				(unsigned long long)new_dir->i_ino);

Is it possible for the user to trigger this mlog(ML_ERROR, "....") print at
will? If so we need to make it a debug print otherwise we risk blowing up
systemlog when someone abuses rename().
	--Mark

--
Mark Fasheh
