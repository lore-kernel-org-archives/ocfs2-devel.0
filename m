From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 11 Jul 2008 13:02:14 -0700
Subject: [Ocfs2-devel] [BUGFIX][PATCH v2 1/2] configfs: Prevent
	userspace from	creating new entries under attaching directories
In-Reply-To: <1215183366-17479-2-git-send-email-louis.rilling@kerlabs.com>
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
	<1215183366-17479-2-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <20080711200214.GA22577@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: joel.becker@hawkmoon.kerlabs.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Jul 04, 2008 at 04:56:05PM +0200, Louis Rilling wrote:
> Changelog:
>   - Rename configfs_validate_dir() in configfs_dir_set_ready()
>   - Introduce configfs_dirent_is_ready() helper to unbloat a bit
>     CONFIGFS_USET_CREATING checks

	Looks good.

Joel

-- 

"Lately I've been talking in my sleep.
 Can't imagine what I'd have to say.
 Except my world will be right
 When love comes back my way."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
