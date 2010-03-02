From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 1 Mar 2010 18:32:17 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Move ocfs2 ioctl definitions
 from ocfs2_fs.h to new added ocfs2_ioctl.h.
In-Reply-To: <4B8C7304.8070108@oracle.com>
References: <1266997872-17091-1-git-send-email-tiger.yang@oracle.com>
	<20100302012121.GC447@mail.oracle.com>
	<4B8C7304.8070108@oracle.com>
Message-ID: <20100302023217.GD447@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 02, 2010 at 10:08:04AM +0800, tristan wrote:
> Currently 'resize.h' and 'file.h' are using ioctl structures from
> 'ocfs2_ioctl.h', don't like 'resize.h', which only was included in
> 'resize.c', 'file.h' instead was referred everywhere:
> 
> We therefore need to add 'ocfs2_ioctl.h' in many C sources to avoid
> compile warnings.

	That's right, you put it in the C sources.  This way we know
what includes each C file has, and only the C files needing the include
file actually include it.

Joel

-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
