From: Randy Dunlap <rdunlap@infradead.org>
Date: Fri, 29 May 2020 12:42:01 -0700
Subject: [Ocfs2-devel] linux-next: Tree for May 29 (ocfs2)
In-Reply-To: <20200529215624.5e52c341@canb.auug.org.au>
References: <20200529215624.5e52c341@canb.auug.org.au>
Message-ID: <fec54c99-d4c6-c05d-3aa9-ab07fd80ed51@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rothwell <sfr@canb.auug.org.au>, Linux Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com

On 5/29/20 4:56 AM, Stephen Rothwell wrote:
> Hi all,
> 
> News: there will be no linux-next release on Monday.
> 
> Changes since 20200528:
> 


on x86_64:
when CONFIG_INET is not set/enabled:

ld: fs/ocfs2/cluster/tcp.o: in function `o2net_accept_many':
tcp.c:(.text+0x2e06): undefined reference to `tcp_sock_set_nodelay'
ld: tcp.c:(.text+0x2e18): undefined reference to `tcp_sock_set_user_timeout'
ld: fs/ocfs2/cluster/tcp.o: in function `o2net_start_connect':
tcp.c:(.text+0x3391): undefined reference to `tcp_sock_set_nodelay'
ld: tcp.c:(.text+0x33a3): undefined reference to `tcp_sock_set_user_timeout'


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
