From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Thu, 22 May 2008 13:40:48 +0200
Subject: [Ocfs2-devel] [RFC][PATCH 0/4] configfs: Make nested default groups
	lockdep-friendly v2
Message-ID: <20080522114048.265996107@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi all,

The following patchset is another try to make configfs recursive inode locking
lockdep-friendly. This time lockdep_off()/lockdep_on() are not inserted, but
I_MUTEX_* lockdep sub-classes are tweaked to allow some variable-length
recursion on the spirit of I_MUTEX_PARENT -> I_MUTEX_CHILD -> I_MUTEX_CHILD + 1
-> ... The lockdep annotations added in configfs are a variant of a previously
submitted patch (see
http://oss.oracle.com/pipermail/ocfs2-devel/2008-May/002214.html ), with a much
lighter footprint, thanks to a suggestion from Joel.

Thanks for reviewing.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
