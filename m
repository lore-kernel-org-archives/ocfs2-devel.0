From: Arjan van de Ven <arjan@infradead.org>
Date: Tue, 20 May 2008 16:58:55 -0000
Subject: [Ocfs2-devel] [RFC][PATCH 0/3] configfs: Make nested default
 groups lockdep-friendly
In-Reply-To: <20080520163320.025971210@kerlabs.com>
References: <20080520163320.025971210@kerlabs.com>
Message-ID: <20080520095810.1d50d247@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Joel.Becker@oracle.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, 20 May 2008 18:33:20 +0200
Louis Rilling <Louis.Rilling@kerlabs.com> wrote:

> Hi all,
> 
> The following patches fix lockdep warnings resulting from (correct)
> recursive locking in configfs.
> 
> Current lockdep annotations for inode mutexes in configfs are
> lockdep-friendly provided that:
> 1/ config_groups have at most one level of default groups (see
>    configfs_attach_group()),
> 2/ config_groups having default groups are never removed (see
>    configfs_detach_prep()).
> 
> Since lockdep does not handle such correct recursion, the idea is to
> insert lockdep_off()/lockdep_on() for inode mutexes as soon as the
> level of recursion of the I_MUTEX_PARENT -> I_MUTEX_CHILD dependency
> pattern increases.

I'm... not entirely happy with such a solution ;(

there must be a better one.
