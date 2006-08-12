From: =?ISO-8859-1?Q?S=E9bastien_CRAMATTE?= <s.cramatte@wanadoo.fr>
Date: Sat Aug 12 03:14:55 2006
Subject: [Ocfs2-devel] Can't compile OCFS2 against RHEL4 + FreeVps patch
Message-ID: <44DDAA18.2020408@wanadoo.fr>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

I need to compile OCFS2 1.2.3.1 against RHEL 4 + Freevps patch 
(www.freevps.com)
But when I try, I obtain this message ...

/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster/tcp.c: In function 
`o2net_start_connect':
/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster/tcp.c:1372: warning: passing arg 1 
of `sock_create' makes pointer from integer without a cast
/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster/tcp.c:1372: warning: passing arg 4 
of `sock_create' makes integer from pointer without a cast
/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster/tcp.c:1372: error: too few 
arguments to function `sock_create'
/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster/tcp.c: In function 
`o2net_accept_one':
/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster/tcp.c:1578: warning: passing arg 1 
of `sock_create_lite' makes pointer from integer without a cast
/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster/tcp.c:1578: warning: passing arg 4 
of `sock_create_lite' makes integer from pointer without a cast
/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster/tcp.c:1578: error: too few 
arguments to function `sock_create_lite'
/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster/tcp.c: In function 
`o2net_open_listening_sock':
/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster/tcp.c:1717: warning: passing arg 1 
of `sock_create' makes pointer from integer without a cast
/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster/tcp.c:1717: warning: passing arg 4 
of `sock_create' makes integer from pointer without a cast
/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster/tcp.c:1717: error: too few 
arguments to function `sock_create'
make[5]: *** [/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster/tcp.o] Error 1
make[4]: *** [/usr/src/ocfs2-1.2.3/fs/ocfs2/cluster] Error 2
make[3]: *** [/usr/src/ocfs2-1.2.3/fs/ocfs2] Error 2
make[2]: *** [_module_/usr/src/ocfs2-1.2.3/fs] Error 2
make[2]: Leaving directory `/usr/src/freevps/kernel_26'
make[1]: *** [build-modules] Error 2
make[1]: Leaving directory `/usr/src/ocfs2-1.2.3/fs'
make: *** [fs] Error 2

Does it exist a patch for RedHat  RHEL 4...
I can't use precompiled module

I've readen somewhere that that adding "0"  as  fifth parameter solve 
problem  ....
I've done this with DRBD 0.8pre3. Using this tweak, I can compile DRBD 
0.8 and load the module ... but I can't run drbdadmin (crash my server)

As you can see, this is the same problem between DRBD and OCFS, so maybe 
someone know how can to fix this ...
I would like to make a diff between vanilla source and RHEL4 source to 
see how use sock_create


Regards





---- FOR REFERENCE MY DRBD 0.8 patch ----

----- my redhat  drbd_receiver.c  patch  ----
--- drbd-8.0pre3/drbd/drbd_receiver.c   2006-07-11 16:41:54.000000000 +0000
+++ drbd-8.0pre3-patched/drbd/drbd_receiver.c   2006-07-11 
16:19:40.000000000 +0000
@@ -428,7 +428,7 @@
    if (err)
            goto out;

-       if (sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP, &newsock))
+       if (sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP, &newsock, 0))
            goto out;

    newsock->type = sock->type;
@@ -547,7 +547,7 @@
    struct socket *sock;
    struct sockaddr_in src_in;

-       err = sock_create(AF_INET, SOCK_STREAM, 0, &sock);
+       err = sock_create(AF_INET, SOCK_STREAM, 0, &sock, 0);
    if (err) {
            ERR("sock_creat(..)=%d\n", err);
            return NULL;
@@ -596,7 +596,7 @@
    int err;
    struct socket *sock,*sock2;

-       err = sock_create(AF_INET, SOCK_STREAM, 0, &sock2);
+       err = sock_create(AF_INET, SOCK_STREAM, 0, &sock2, 0);
    if (err) {
            ERR("sock_creat(..)=%d\n", err);
            return NULL;
