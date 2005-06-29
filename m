From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Jun 29 16:30:52 2005
Subject: [Ocfs2-devel] Re: [-mm patch] CONFIGFS_FS shouldn't be user-visible
In-Reply-To: <20050624080315.GC26545@stusta.de>
References: <20050624080315.GC26545@stusta.de>
Message-ID: <20050629213038.GA23823@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@stusta.de>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Fri, Jun 24, 2005 at 10:03:15AM +0200, Adrian Bunk wrote:
> I haven't found any reason why CONFIGFS_FS is user-visible.
> Other parts of the kernel using configfs should simply select it.

	Doesn't work for external modules that might want to use it.
Imagine that configfs gets merged before OCFS2, which depends on it.

Joel

-- 

"There is shadow under this red rock.
 (Come in under the shadow of this red rock)
 And I will show you something different from either
 Your shadow at morning striding behind you
 Or your shadow at evening rising to meet you.
 I will show you fear in a handful of dust."

Joel Becker
Senior Member of Technical Staff
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
