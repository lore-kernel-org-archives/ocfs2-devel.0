From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 24 Oct 2008 00:43:53 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/xattr: Proper hash
	collision	handle in bucket division.v2
In-Reply-To: <49016807.9000901@oracle.com>
References: <1224218678-32196-3-git-send-email-tao.ma@oracle.com>
	<1224204876-26802-1-git-send-email-tao.ma@oracle.com>
	<20081023232030.GE12751@mail.oracle.com>
	<49011C51.1030806@oracle.com>
	<20081024011451.GH12751@mail.oracle.com>
	<490124A0.1020407@oracle.com>
	<20081024060238.GB31082@ca-server1.us.oracle.com>
	<49016807.9000901@oracle.com>
Message-ID: <20081024074353.GC31082@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 24, 2008 at 02:15:35PM +0800, Tao Ma wrote:
> Joel Becker wrote:
>> 	I have an idea to do what you're doing, but cleaner.  I'll look
>> at cmp_xe and try again in the morning.
> cool, so waiting for your perfect code. ;)

Zing!  You got me :-)

Joel

-- 

"It is not the function of our government to keep the citizen from
 falling into error; it is the function of the citizen to keep the
 government from falling into error."
	- Robert H. Jackson

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
