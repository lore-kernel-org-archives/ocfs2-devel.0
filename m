From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Mar 19 20:10:12 2004
Subject: [Ocfs2-devel] Bug in ocfs_file_entry struct for 2.6
In-Reply-To: <20040319235852.GA22829@ca-server1.us.oracle.com>
References: <60C14C611F1DDD4198D53F2F43D8CA3B0E3E08@orsmsx410.jf.intel.com>
	<20040319235852.GA22829@ca-server1.us.oracle.com>
Message-ID: <20040320021006.GW18020@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2004 at 03:58:52PM -0800, Mark Fasheh wrote:
> > I noticed that it defines:
> > 
> >     __u16 dev_major;                  // NUMBER RANGE(0,65535)
> >     __u16 dev_minor;                  // NUMBER RANGE(0,65535)

	The write answer is to make it __u32 rdev, and then use the
proper MAJOR/MINOR/major/minor/to_kdev_t routines on it.  This is what
all other filesystems do.

Joel

-- 

Life's Little Instruction Book #15

	"Own a great stereo system."

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
