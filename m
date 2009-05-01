From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 1 May 2009 04:19:32 -0700
Subject: [Ocfs2-devel] [PATCH 17/39] ocfs2: Add ioctl for reflink.
In-Reply-To: <20090501073456.GA22000@lst.de>
References: <49F95A79.6040806@oracle.com>
	<1241045931-24607-17-git-send-email-tao.ma@oracle.com>
	<20090501073456.GA22000@lst.de>
Message-ID: <20090501111931.GA29617@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, May 01, 2009 at 09:34:56AM +0200, Christoph Hellwig wrote:
> On Thu, Apr 30, 2009 at 06:58:29AM +0800, Tao Ma wrote:
> > The ioctl will take 2 parameters: old_path and new_path and
> > works like link.
> 
> As discussed during the FS/Storage summit please make this a proper
> sys_reflink system call and don't add a stupid ioctl.

Christoph,
	Be nice to Tao, I haven't sent him the syscall yet :-)

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
