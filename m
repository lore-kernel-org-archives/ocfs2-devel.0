From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Thu, 12 Jun 2008 17:26:45 +0200
Subject: [Ocfs2-devel] [RFC][PATCH 0/3] configfs: Miscellaneous fixes
Message-ID: <20080612152645.445504681@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi,

The following patches fix few bugs/APIs in configfs. The third one depends on
the patch introducing configfs_dirent_lock previously submitted in 
http://lkml.org/lkml/2008/6/12/232

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
