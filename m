From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Thu, 9 May 2013 10:22:55 -0700
Subject: [Ocfs2-devel] Patch request reviews,
 for node reconnecting with other nodes whose node number is little
 than local, thanks a lot.
In-Reply-To: <CAEeiSHXTeiH94R33ARx0-Lj7rBaLWUpCHscsdYH3WcOSdkubNw@mail.gmail.com>
References: <71604351584F6A4EBAE558C676F37CA417BD78AA@H3CMLB02-EX.srv.huawei-3com.com>
	<CAEeiSHXTeiH94R33ARx0-Lj7rBaLWUpCHscsdYH3WcOSdkubNw@mail.gmail.com>
Message-ID: <CAEeiSHXXt0-hmkbGLDvdAzRGbsHwOvNfZQz_uAmU2m-cJUv2tg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Resending as my reply bounced.

On Thu, May 9, 2013 at 10:01 AM, Sunil Mushran <sunil.mushran@gmail.com>wrote:

> A better fix is to _not_ disconnect on o2net timeout once a connection has
> been
> cleanly established. Only disconnect on o2hb timeout.
>
> The reconnects are a problem as we could lose packets and not be aware of
> it
> leading to o2dlm hangs.
>
> IOW, this patch looks to be papering over one specific problem and does
> not fix the
> underlying issue.
>
>
>
>  On Tue, May 7, 2013 at 7:43 PM, Guozhonghua <guozhonghua@h3c.com> wrote:
>
>>
>>
>> Hi, everyone,
>>
>> I had have a test with eight nodes and find one issue.
>>
>>
>> The Linux kernel version is 3.2.40.
>>
>>
>>
>> As I migrate processes from one node to another, those processes is open
>> the files on the OCFS2 storage. Sometime one node shutdown TCP connection
>> with that node whose node number is larger because long time without any
>> message from it.
>>
>> As the TCP connection shutdown, the node whose number larger did not
>> restart connection to the node, whose number is little and shutdown the TCP
>> connection.
>>
>> So I review the code of the cluster and find it may be a bug.
>>
>>
>>
>> I changed it and have a test.
>>
>>
>>
>> Is there anybody having time to view and make sure that those changes is
>> correct?
>>
>> Thanks a lot.
>>
>>
>>
>> The diff file is as below, of the file is /cluster/tcp.c:
>>
>>
>>
>> root at gzh-dev:/home/dev/test_replace/ocfs2_ko# diff -pu
>> ocfs2-ko-3.2-compare/cluster/tcp.c ocfs2-ko-3.2/cluster/tcp.c
>>
>> --- ocfs2-ko-3.2-compare/cluster/tcp.c  2012-10-29 19:33:19.534200000
>> +0800
>>
>> +++ ocfs2-ko-3.2/cluster/tcp.c        2013-05-08 09:33:16.386277310 +0800
>>
>> @@ -1699,6 +1698,10 @@ static void o2net_start_connect(struct w
>>
>>       if (ret == -EINPROGRESS)
>>
>>               ret = 0;
>>
>> +      /** Reset the timeout with 0 to avoid connection again */
>>
>> +      if (ret == 0) {
>>
>> +              atomic_set(&nn->nn_timeout, 0);
>>
>> +      }
>>
>> out:
>>
>>       if (ret) {
>>
>>               printk(KERN_NOTICE "o2net: Connect attempt to " SC_NODEF_FMT
>>
>> @@ -1725,6 +1728,11 @@ static void o2net_connect_expired(struct
>>
>>        spin_lock(&nn->nn_lock);
>>
>>       if (!nn->nn_sc_valid) {
>>
>> +              /** trigger reconnect with other nodes whose node number
>> is little than local
>>
>> +              *  while they are still able to access the storage
>>
>> +              */
>>
>> +              atomic_set(&nn->nn_timeout, 1);
>>
>> +
>>
>>                printk(KERN_NOTICE "o2net: No connection established with "
>>
>>                      "node %u after %u.%u seconds, giving up.\n",
>>
>>                    o2net_num_from_nn(nn),
>>
>>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130509/a6f76ad4/attachment-0001.html 
