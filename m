From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 1 Apr 2011 09:54:58 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] VFS/ioctl: Add punching-hole support
 to ioctl().
In-Reply-To: <20110401003450.GD7484@dhcp231-156.rdu.redhat.com>
References: <1301556810-8438-1-git-send-email-tristan.ye@oracle.com>
	<4D94EEC3.2030206@oracle.com>
	<20110331225618.GB7484@dhcp231-156.rdu.redhat.com>
	<20110331234454.GB18808@noexit>
	<20110401003450.GD7484@dhcp231-156.rdu.redhat.com>
Message-ID: <20110401165458.GA25355@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@redhat.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>, Tristan Ye <tristan.ye@oracle.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, chris.mason@oracle.com, tm@tao.ma

On Thu, Mar 31, 2011 at 08:34:50PM -0400, Josef Bacik wrote:
> > 	More interesting would be to bring the ioctls up to generic code
> > and have them backended by fallocate.  I'm not sure they map without
> > looking deeper, but it's at least an idea.
> > 
> 
> I just did a cursory look and it seems like that would work out ok.  Thanks,

	Note that ocfs2 and xfs have identical ioctl values (ocfs2
copied xfs's on purpose).

Joel

-- 

Life's Little Instruction Book #306

	"Take a nap on Sunday afternoons."

			http://www.jlbec.org/
			jlbec at evilplan.org
