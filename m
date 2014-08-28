From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Wed, 27 Aug 2014 18:16:23 -0700
Subject: [Ocfs2-devel] A deadlock when system do not has sufficient
	memory
In-Reply-To: <53FD3B12.5070802@huawei.com>
References: <53F41CAE.2040204@huawei.com> <53F6FFB7.1090305@huawei.com>
	<CAEeiSHVP60=zNcP-Q2bCD_BdD3g8v1a__Vyn4ZMF_8Z97cpE8g@mail.gmail.com>
	<53FA99FD.1090008@huawei.com>
	<CAEeiSHWiPZHKC5gwLTuuZAm3xUeGT48BLNs97qdUgZSMM+AFZQ@mail.gmail.com>
	<53FACC99.8070701@huawei.com>
	<CAEeiSHXurWFQYX5g3oi1U3-Ma4YpKUYF4PaBWyU0oAGxNFTuLg@mail.gmail.com>
	<53FAD239.7020709@huawei.com>
	<CAEeiSHXmTbTJsEFbE4C1oZxNFwgR08P+f7KmC3r3usLeUMC1DQ@mail.gmail.com>
	<53FD3B12.5070802@huawei.com>
Message-ID: <CAEeiSHXLKQBRXuUw6J7X0dOP36oJ8q3-BzDwOEdLf-zF1i4bRw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

What is o2net_wq waiting on that is preventing it from processing the reply
for unlock?
Sorry for being a bit slow. Do you have the raw stacks of the deadlock?

I mean, making that alloc NOFS should not be an issue. But I would like to
understand whether we are fixing the actual problem or not.

Sunil


On Tue, Aug 26, 2014 at 6:57 PM, Xue jiufei <xuejiufei@huawei.com> wrote:

> Hi, Sunil
> On 2014/8/26 1:13, Sunil Mushran wrote:
> > On Sun, Aug 24, 2014 at 11:05 PM, Joseph Qi <joseph.qi@huawei.com
> <mailto:joseph.qi@huawei.com>> wrote:
> >
> >     On 2014/8/25 13:45, Sunil Mushran wrote:
> >     > Please could you expand on that.
> >     >
> >     In our scenario, one node can mount multiple volumes across the
> >     cluster.
> >     For instance, N1 has mounted ocfs2 volumes say volume1, volume2,
> >     volume3. And volume3 may do umount/mount during runtime of other
> >     volumes.
> >
> >
> > I meant expand on the deadlock. Say we are mounting a new volume and
> that triggers a inode cleanup. That inode being cleaned up will have to be
> from one of the mounted volumes. How can this lead to a deadlock?
> >
> > Two variations:
> > a) Node death leading to recovery during the mount.
> > b) Mount atop a mount.
> >
> > But I cannot still see a deadlock in either scenario.
> The deadlock situation is just the same as the I described in my first
> mail.
> o2net_wq
> -> dlm_query_region_handler
> -> kmalloc(no sufficient memory)
> -> triggers ocfs2 inodes cleanup
> -> ocfs2_drop_lock
> -> call o2net_send_message to send unlock message
> -> wait_event(nsw.ns_wq, o2net_nsw_completed(nn, &nsw))
>    to wait for the reply from master
> -> tcp layer receive the reply, call o2net_data_ready
> -> queue sc_rx_work, but o2net_wq cannot handle this work
> so it triggers the deadlock, o2net_wq is waiting itself to
> handle unlock reply and complete the nsw.
>
> Thanks.
> Xuejiufei
>
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140827/0df968ca/attachment.html 
