From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 3 Nov 2010 23:19:29 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Try to free truncate log when
 meeting ENOSPC in write.
In-Reply-To: <4CD246E1.1030608@oracle.com>
References: <1288078148-6343-1-git-send-email-tao.ma@oracle.com>
	<20101104014623.GC14640@mail.oracle.com>
	<4CD246E1.1030608@oracle.com>
Message-ID: <20101104061928.GA22663@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 04, 2010 at 01:38:41PM +0800, Tao Ma wrote:
> yes, I have run the test case overnight and didn't hit ENOSPC any
> more. So do you think of accepting it? If yes, I will regenerate the
> patch for your merge.

	Please do.  Thanks.

Joel

-- 

"The question of whether computers can think is just like the question
 of whether submarines can swim."
	- Edsger W. Dijkstra

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
