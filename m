From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 1 Oct 2008 23:12:09 -0700
Subject: [Ocfs2-devel] [PATCH 13/39] ocfs2: Add extended attribute
	support
In-Reply-To: <1222293680-15451-14-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-14-git-send-email-mfasheh@suse.com>
Message-ID: <20081001231209.44417bc1.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, tiger.yang@oracle.com

> On Wed, 24 Sep 2008 15:00:54 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> +		case Opt_user_xattr:
> +			mopt->mount_opt &= ~OCFS2_MOUNT_NOUSERXATTR;
> +			break;
> +		case Opt_nouser_xattr:
> +			mopt->mount_opt |= OCFS2_MOUNT_NOUSERXATTR;
> +			break;

Is there a documentation update for these?
