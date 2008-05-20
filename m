From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Tue, 20 May 2008 18:33:20 +0200
Subject: [Ocfs2-devel] [RFC][PATCH 0/3] configfs: Make nested default groups
	lockdep-friendly
Message-ID: <20080520163320.025971210@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi all,

The following patches fix lockdep warnings resulting from (correct) recursive
locking in configfs.

Current lockdep annotations for inode mutexes in configfs are lockdep-friendly
provided that:
1/ config_groups have at most one level of default groups (see
   configfs_attach_group()),
2/ config_groups having default groups are never removed (see
   configfs_detach_prep()).

Since lockdep does not handle such correct recursion, the idea is to insert
lockdep_off()/lockdep_on() for inode mutexes as soon as the level of recursion
of the I_MUTEX_PARENT -> I_MUTEX_CHILD dependency pattern increases.

The patches apply to latest configfs in linux-2.6.git (
commit 8033c6e9736c29cce5f0d0abbca9a44dffb20c39 for instance ), and were
successfully tested.

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
