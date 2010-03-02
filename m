From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 2 Mar 2010 14:20:57 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Move ocfs2 ioctl definitions
 from ocfs2_fs.h to newly added ocfs2_ioctl.h
In-Reply-To: <1267509583-6160-1-git-send-email-tristan.ye@oracle.com>
References: <1267509583-6160-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100302222057.GA11860@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 02, 2010 at 01:59:42PM +0800, Tristan Ye wrote:
> Currently we were adding ioctl cmds/structures for ocfs2 into ocfs2_fs.h
> which was used for define ocfs2 on-disk layout. That sounds a little bit
> confusing, and it may be quickly polluted espcially when growing the
> ocfs2_info_request ioctls afterwards(it will grow i bet).
> 
> As a result, such OCFS2 IOCs do need to be placed somewhere other than
> ocfs2_fs.h, a separated ocfs2_ioctl.h will be added to store such ioctl
> structures and definitions which could also be used from userspace to
> invoke ioctls call.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

	This is now part of the 'merge-window' branch of ocfs2.git.
Please cook up the identical patch for ocfs2-tools.

Joel

-- 

Life's Little Instruction Book #226

	"When someone hugs you, let them be the first to let go."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
