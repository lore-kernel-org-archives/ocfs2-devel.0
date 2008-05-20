From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 20 May 2008 14:41:15 -0700
Subject: [Ocfs2-devel] [RFC][PATCH 0/3] configfs: Make nested
	default	groups lockdep-friendly
In-Reply-To: <20080520163320.025971210@kerlabs.com>
References: <20080520163320.025971210@kerlabs.com>
Message-ID: <20080520214115.GF26609@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, May 20, 2008 at 06:33:20PM +0200, Louis Rilling wrote:
> The following patches fix lockdep warnings resulting from (correct) recursive
> locking in configfs.
> 
> Current lockdep annotations for inode mutexes in configfs are lockdep-friendly
> provided that:
> 1/ config_groups have at most one level of default groups (see
>    configfs_attach_group()),
> 2/ config_groups having default groups are never removed (see
>    configfs_detach_prep()).
> 
> Since lockdep does not handle such correct recursion, the idea is to insert
> lockdep_off()/lockdep_on() for inode mutexes as soon as the level of recursion
> of the I_MUTEX_PARENT -> I_MUTEX_CHILD dependency pattern increases.

	Hmm, this is definitely a more readable solution than the
previous, but I'm also with Arjan that it's scary :-)

Joel

-- 

"Ninety feet between bases is perhaps as close as man has ever come
 to perfection."
	- Red Smith

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
