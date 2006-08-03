From: tao.ma <tao.ma@oracle.com>
Date: Thu Aug  3 01:27:44 2006
Subject: [Ocfs2-devel] A patch for ocfs2 source configuration process.
Message-ID: <44D1B373.7020107@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
     I have downloaded the newest source code ocfs2-1.2.3.tar.gz from
oss.oracle.com.
     After do the configuration I find a strange thing. Although my
kernel is "2.6.9-11.19AX"(Asianux2.0 on a vmware server with a single
processor configured), the configuration find that it is
2.6.9-11.19AX-smp. So after I make and install, those *.ko went to the
wrong place.
The reason is:
1. When vendor/ax2/vendor.guess runs.
The script is :if [ "`rpm -qf /etc/asianux-release --qf '%{VERSION}'
2>/dev/null`" != "8AX" ]
while in my machine it is "2.0", not "8AX".

I also modify the script in vendor.guess. In asianux2.0, In /etc, you
can find
redhat-release and asianux-release.  So the vendor.guess will get the
wrong string
"ax2
rhel4".

Attachment is my patch. Hope it can help.


-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2.patch
Type: text/x-patch
Size: 1011 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20060803/58a3721f/ocfs2.bin
