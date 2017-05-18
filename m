From: Gang He <ghe@suse.com>
Date: Thu, 18 May 2017 01:11:26 -0600
Subject: [Ocfs2-devel] kernel BUG at ocfs2/alloc.c:1514
In-Reply-To: <1495044743.629431015@webmail.futurefoam.com>
References: <1495044743.629431015@webmail.futurefoam.com>
Message-ID: <591DB99E020000F900076BEB@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Russell,

I just went through the bug description from the link below, 
Could you always meet this issue in your testing environment? since it looks like a simple direct write.
Second, could you describe the whole reproduce steps in details or provide a testing script which can make this bug happen?
Because, in our normal environment, I believe we can not meet this bug easily since the kernel version v4.9 is very new.


Thanks
Gang


>>> 

> Copious stack traces available at
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=841144 
>  
> 
> --
> Russell Mosemann
> IT Manager | Future Foam, Inc.
> 1610 Avenue N | Council Bluffs, IA 51501-1071
> O: (712) 323-9122 Ext 228
> F: (712) 323-0158
