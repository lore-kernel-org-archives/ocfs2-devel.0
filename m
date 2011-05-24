From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 23 May 2011 23:57:35 -0700
Subject: [Ocfs2-devel] [PATCH 1/3 V2] ocfs2: Add ocfs2_trim_fs for SSD
	trim support.
In-Reply-To: <1306118205-3148-1-git-send-email-tm@tao.ma>
References: <4DD9C1A3.5020005@tao.ma>
	<1306118205-3148-1-git-send-email-tm@tao.ma>
Message-ID: <20110524065734.GD24290@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 23, 2011 at 10:36:43AM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Add ocfs2_trim_fs to support trimming freed clusters in the
> volume. A range will be given and all the freed clusters greater
> than minlen will be discarded to the block layer.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

	The TRIM patches are now in the merge-window branch of
ocfs2.git.

Joel

-- 

"In the room the women come and go
 Talking of Michaelangelo."

			http://www.jlbec.org/
			jlbec at evilplan.org
