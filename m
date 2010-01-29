From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 29 Jan 2010 13:46:42 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Do not downconvert if the lock
 level is already compatible
In-Reply-To: <20100129181409.GV11402@wotan.suse.de>
References: <1264787051-7491-1-git-send-email-sunil.mushran@oracle.com>
	<20100129181409.GV11402@wotan.suse.de>
Message-ID: <20100129214642.GC30409@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 29, 2010 at 10:14:09AM -0800, Mark Fasheh wrote:
> Hmm, looks like it's the month of dlmglue fixes?  :)

	fs/dlm is far more asynchronous than o2dlm, and boy it shows us
up ;-)

Joel

-- 

Life's Little Instruction Book #396

	"Never give anyone a fruitcake."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
