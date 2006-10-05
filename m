From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Oct  5 14:51:42 2006
Subject: [Ocfs2-devel] Re: linux 2.6.19-rc1 build failed
In-Reply-To: <200610051955.09067.toralf.foerster@gmx.de>
References: <200610051955.09067.toralf.foerster@gmx.de>
Message-ID: <20061005215137.GN6485@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 05, 2006 at 07:55:06PM +0200, Toralf F?rster wrote:
> the compile of the attached .config failed :
> 
> git log :
> 
> commit d223a60106891bfe46febfacf46b20cd8509aaad
> Author: Linus Torvalds <torvalds@g5.osdl.org>
> Date:   Wed Oct 4 19:57:05 2006 -0700
> 
> 
> fs/built-in.o: In function `send_shutdown':
> lowcomms.c:(.text+0x504e5): undefined reference to `kernel_sendmsg'
> fs/built-in.o: In function `receive_from_sock':
> lowcomms.c:(.text+0x5093d): undefined reference to `kernel_recvmsg'
> fs/built-in.o: In function `init_sock':
> lowcomms.c:(.text+0x50d2c): undefined reference to `sock_create_kern'
> lowcomms.c:(.text+0x50e78): undefined reference to `sock_release'
> fs/built-in.o: In function `initiate_association':
> lowcomms.c:(.text+0x512cb): undefined reference to `kernel_sendmsg'
> fs/built-in.o: In function `send_to_sock':
> lowcomms.c:(.text+0x51494): undefined reference to `kernel_sendmsg'
> make: *** [.tmp_vmlinux1] Error 1
I think you're looking for the GFS2 folks...
	--Mark



--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
