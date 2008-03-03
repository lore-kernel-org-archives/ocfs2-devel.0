From: Tao Ma <tao.ma@oracle.com>
Date: Mon Mar  3 19:21:32 2008
Subject: [Ocfs2-devel] [PATCH 3/3] Add inode stealing
	for	ocfs2_reserve_new_inode.V3
In-Reply-To: <47CCBA8C.1020203@oracle.com>
References: <20080303091251.GA18140@tma-pc1.cn.oracle.com>
	<47CCB2F8.3040702@oracle.com> <47CCB7E0.6000402@oracle.com>
	<47CCBA8C.1020203@oracle.com>
Message-ID: <47CCC015.1080009@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran wrote:
> Tao Ma wrote:
>> I use "i" because I am always worried about if I can't handle the 
>> condition carefully. :( So you think using "i" is not gracefully, or 
>> not easy to understand, or any other reason?
> Mostly unnecessary. We are going circular and want to stop
> when we reach our slot.
> 
OK, I will use "while".
Another concern, we should stop when we reach the first test one, not 
our own slot.
so it should be "while (slot != start_slot)".
