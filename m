From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Tue, 30 Jun 2015 03:18:06 +0000
Subject: [Ocfs2-devel] o2net_sendpage reviews, thanks
References: <2015060621065807886420@h3c.com>, <2015063011132144102146@h3c.com>
Message-ID: <2015063011180600247349@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Hi

1.  In the callback o2net_sendpage -> sendpage()
2.  If sendpage (tcp socket send) continuously returns -EAGAIN, then get into an endless loop,
    even though the function of cond_resched() have already used.
3.  I think it is not reasonable, try to continuously send 20 times returns -EAGAIN ,
    shutdown the socket to avoid affecting the entire cluster.

Finally, any feedback about this process (positive or negative) would be greatly appreciated.

--- tcp.c   2015-06-30 11:46:54.727447919 +0800

+++ tcp.c.diff  2015-06-30 11:52:12.823447881 +0800

@@ -949,6 +949,7 @@

 {

    struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);

    ssize_t ret;

+   int send_fails = 20;

    while (1) {

        mutex_lock(&sc->sc_send_lock);

@@ -959,10 +960,11 @@

        mutex_unlock(&sc->sc_send_lock);

        if (ret == size)

            break;

-       if (ret == (ssize_t)-EAGAIN) {

+       if (ret == (ssize_t)-EAGAIN && send_fails > 0) {

            mlog(0, "sendpage of size %zu to " SC_NODEF_FMT

                 " returned EAGAIN\n", size, SC_NODEF_ARGS(sc));

            cond_resched();

+           --send_fails;

            continue;

        }
        mlog(ML_ERROR, "sendpage of size %zu to " SC_NODEF_FMT


syslog:

/var/log/syslog:Jun 29 09:32:58 cvk47 kernel: [156022.769539] (kworker/u130:1,12041,9):o2net_sendpage:1026 sendpage of size 24 to node cvk61 (num 5) at 172.16.202.61:7100 returned EAGAIN

/var/log/syslog:Jun 29 09:32:58 cvk47 kernel: [156022.769542] (kworker/u130:1,12041,9):o2net_sendpage:1026 sendpage of size 24 to node cvk61 (num 5) at 172.16.202.61:7100 returned EAGAIN

/var/log/syslog:Jun 29 09:32:58 cvk47 kernel: [156022.769544] (kworker/u130:1,12041,9):o2net_sendpage:1026 sendpage of size 24 to node cvk61 (num 5) at 172.16.202.61:7100 returned EAGAIN

/var/log/syslog:Jun 29 09:32:58 cvk47 kernel: [156022.769546] (kworker/u130:1,12041,9):o2net_sendpage:1026 sendpage of

________________________________
zhangguanghui 10102
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150630/ca5d1058/attachment.html 
