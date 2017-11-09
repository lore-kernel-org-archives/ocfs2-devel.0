From: =?UTF-8?Q?BASSAGET_C=C3=A9dric?= <cedric.bassaget.ml@gmail.com>
Date: Thu, 9 Nov 2017 14:04:42 +0100
Subject: [Ocfs2-devel] Adding new node to an online OCFS2 cluster
In-Reply-To: <244978f0-b02a-ee03-27fb-c146b18bf965@gmail.com>
References: <CAN+OZjSjt7wMF=caKEkZtz+UJXC-byHGTOLKP0zp7epLGUqu-A@mail.gmail.com>
	<244978f0-b02a-ee03-27fb-c146b18bf965@gmail.com>
Message-ID: <CAN+OZjRbp_TaXQo1=WfUT_-_12gay2F0v8LLz57duq3UPM6tfQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph.
my shared disk is formatted with 2 slots :
root at debian2:~# debugfs.ocfs2 /dev/sdb -R stats | grep Slots
Max Node Slots: 2

I was hoping I can change it without unmounting my partition but it seems
not :
root at debian2:~# tunefs.ocfs2 -N 3 /dev/sdb
tunefs.ocfs2: Trylock failed while opening device "/dev/sdb"

C?dric


2017-11-09 12:54 GMT+01:00 Joseph Qi <jiangqi903@gmail.com>:

> Hi C?dric,
> I guess it is because your shared disk is formatted with only 2 slots.
> You can check it using debugfs.ocfs2.
> If it is, you may update slot count using tunefs.ocfs2 -N <num_of_slot>.
> Hope it will help you.
>
> Thanks,
> Joseph
>
> On 17/11/9 18:56, BASSAGET C?dric wrote:
> > Hello,
> > As I did not get help on users mailing list, I allow myself to post my
> > question here. Sorry if it's not the right place, but I can't find any
> > documentation.
> >
> > I'm currently running an OCFS2 cluster on two hosts.
> > My ocfs2 partition is an iscsi disk mounted on both hosts debian1 and
> > debian2
> >
> > I need to add a third host (debian3) to this cluster.
> > I've set up  iscsi (& multipath), but now I'm looking for the correct way
> > to add the ocfs2 partition to my existing cluster.
> >
> > root at debian1:~# cat /etc/ocfs2/cluster.conf
> > node:
> >         ip_port = 7777
> >         ip_address = 192.168.0.11
> >         number = 0
> >         name = debian1
> >         cluster = ocfs2
> > node:
> >         ip_port = 7777
> >         ip_address = 192.168.0.12
> >         number = 1
> >         name = debian2
> >         cluster = ocfs2
> > cluster:
> >         node_count = 2
> >         name = ocfs2
> >
> > Same config on debian2.
> >
> > I try to add the new node to the cluster, running this command on nodes
> > debian1 et debian2 :
> >
> > root at debian1:~# o2cb_ctl -C -i -n debian3 -t node -a number=2 -a
> > ip_address=192.168.0.13 -a ip_port=7777 -a cluster=ocfs2
> >
> > my new node is added to the config file, and node_count is incremented
> to 3.
> >
> > then I do a "systemctl reload ocfs2" on debian1 and debian2.
> > I copy the cluster.conf file on debian3 and restart ocfs2 on it.
> >
> > and in dmesg, I get :
> > [  145.582469] o2net: Connected to node debian2 (num 1) at
> 192.168.0.12:7777
> > [  145.582978] o2net: Connected to node debian1 (num 0) at
> 192.168.0.11:7777
> > [  149.631921] o2dlm: Joining domain D2A1F74976E04C55B625CDC8DAC1D5E5
> > [  149.631922] (
> > [  149.631923] 0
> > [  149.631924] 1
> > [  149.631924] 2
> > [  149.631925] ) 3 nodes
> > [  149.634255] (mount.ocfs2,1627,0):ocfs2_find_slot:490 *ERROR: no free
> > slots available!*
> > [  149.634784] (mount.ocfs2,1627,0):ocfs2_mount_volume:1859 ERROR:
> status =
> > -22
> > [  153.738044] o2dlm: Leaving domain D2A1F74976E04C55B625CDC8DAC1D5E5
> > [  153.738153] ocfs2: Unmounting device (254,0) on (node 2)
> > [  153.738174] (mount.ocfs2,1627,0):ocfs2_fill_super:1218 ERROR: status
> =
> > -22
> > [  155.657295] o2net: No longer connected to node debian1 (num 0) at
> > 192.168.0.11:7777
> > [  155.657387] o2net: No longer connected to node debian2 (num 1) at
> > 192.168.0.12:7777
> >
> >
> > Can anyone tell me how I can add a slot, so my new node can work ?
> >
> > Thanks for your help.
> > Regards,
> > C?dric
> >
> >
> >
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171109/4cdf8254/attachment-0001.html 
