From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Aug 19 21:31:33 2004
Subject: [Ocfs2-devel] LTP system call test all pass!
In-Reply-To: <20040820021931.GQ2098@ca-server1.us.oracle.com>
References: <3ACA40606221794F80A5670F0AF15F84053D990A@pdsmsx403>
	<20040820021931.GQ2098@ca-server1.us.oracle.com>
Message-ID: <20040820023128.GR2098@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 19, 2004 at 07:19:31PM -0700, Joel Becker wrote:
> On Fri, Aug 20, 2004 at 10:16:33AM +0800, Ling, Xiaofeng wrote:
> > Does ocfs support loop device now?
> > LSB test need loop device and maybe  a small loop device.  
> 
> 	"Why wouldn't it", is the question, I guess.  What was the problem
> before?  Worth trying out, it might just work.

	I just created a file on ocfs2, ran mkfs.ext3, and mounted it
with loopback ("mount -o loop /ocfs2/loopme /mnt/tmp").  It worked fine.
If you have any problems, let us know.

Joel

-- 

"You can get more with a kind word and a gun than you can with
 a kind word alone."
         - Al Capone

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
