From: Chen, Yukun <yukun.chen@intel.com>
Date: Tue Aug 24 20:01:10 2004
Subject: [Ocfs2-devel] [2.6.6 svn 1364]System hang randomly when writing
	to the same file from different processes of the same node
Message-ID: <B44D37711ED29844BEA67908EAF36F03A38319@pdsmsx401.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the test_filelock.sh scripts, there are 2 steps. One is =
"inode-test.sh" and the other is "filelock-single.sh".=20

In "inode-test.sh" we will load ocfs2 module in %%BOTH 2 NODES %% and do =
some file/dir access across the 2 nodes.

As for "filelock-single.sh", %%ONLY ON ONE NODE%%, we write in one place =
on a file through 2 process simultaneously.

I think the bug will be duplicated if you do some operation across 2 =
nodes before  writing file.

Hope it will help.
Thanx.

Aaron

-----Original Message-----
From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
Sent: 2004=C4=EA8=D4=C225=C8=D5 2:42
To: Chen, Yukun
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [2.6.6 svn 1364]System hang randomly when =
writing to the same file from different processes of the same node

On Mon, Aug 23, 2004 at 10:51:30AM +0800, Chen, Yukun wrote:
> Hi Mark
>=20
> I checked the version and found 1364 on both nodes.=20
Ok. what messages do you see on "node B" when this happens on A? Is node =
B
doing anything in particular?

> Also, I attached the test cases for duplicating such bug.
I might've bitten off more than I can chew by asking for that test code =
:) I
wrote a simple program to write in one place on a file (and I run this
twice) and I couldn't reproduce it yet. Looking through your test =
scripts it
seems that's basically what's going on, but please fill me in on any =
steps
I've missed. I guess I'm looking for an easily reproducable test case. =
Does
this happen every time you run your test suite or is it intermittent?
	--Mark

>=20
> The steps to run the test case:
>=20
> 1. make sure you have setup the tvs environment
>=20
> 2. make sure the two test machine can ssh each other as root without =
password=20
>=20
> 3.update the variable OCFSDEV in test.config to the device name of =
your ocfs2 partition
>=20
> 4.update the variable REMOTE in setup.sh to the remote machine name
>=20
> 5.make sure you have created dir /ocfs (I will updated it later to an =
arbitrary dir which the user can change in the latter version)
>=20
> 6.run "test_filelock.sh"
>=20
> Feel free let me if you have any problems.=20
> Thanx.
>=20
> Aaron
>=20
> -----Original Message-----
> From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
> Sent: 2004??8??21?? 1:43
> To: Chen, Yukun
> Cc: ocfs2-devel@oss.oracle.com
> Subject: Re: [Ocfs2-devel] [2.6.6 svn 1364]System hang randomly when =
writing to the same file from different processes of the same node
>=20
>=20
> Are all your nodes updated to r1364 btw? That'd make a big difference =
as the
> voting flags got juggled around a bit (sorry!) Otherwise it looks like =
it's
> hung doing a TRUNCATE_PAGES message which would be very troubling =
indeed. If
> both nodes *are* in fact, running 1364, you mind posting your test =
code up
> so I can give it a try? Thanks,
> 	--Mark
>=20
> On Fri, Aug 20, 2004 at 04:24:37PM +0800, Chen, Yukun wrote:
> > Hi all
> >
> >=20
> > Steps to duplicate:
> >=20
> > 1.Do some operation ,such as mkdir&touch , on node A and node B
> >=20
> > =20
> >=20
> > 2.on node A process1  write to a file at a specific position(such as =
offset
> > 1000) ,100 times
> >=20
> > =20
> >=20
> > 2.also on node A, at the same time , process2 write to the same file =
at the
> >=20
> > =20
> >=20
> > same position, 100 times
> >=20
> > =20
> >=20
> > Repeat step 1-2 several times, system will hang with the following =
message
> > found in node A:
> >=20
> > =20
> >=20
> > state=3D1, lockid=3D22765568, flags =3D 0x1000, asked type =3D 5 =
master =3D 1, state =3D
> > 0x0, type =3D 5
> >=20
> > (18397) ERROR at /tmp/trunk/src/dlm.c, 461: status =3D -110
> >=20
> > (18397) ERROR at /tmp/trunk/src/vote.c, 910: inode 5558, =
vote_status=3D0,
> > vote_state=3D1, lockid=3D22765568, flags =3D 0x1000, asked type =3D =
5 master =3D 1, state
> > =3D 0x0, type =3D 5
> >=20
> > ...
> >=20
> > =20
> >=20
> > on node B , error message with dmesg:
> >=20
> > Call Trace:
> >=20
> > recalc_task_prio
> >=20
> > shedule
> >=20
> > ocfs_comm_process_msg
> >=20
> > ocfs_dlm_recv_msg
> >=20
> > worker_thread
> >=20
> > ocfs_dlm_recv_msg
> >=20
> > default_wake_function
> >=20
> > ....
> >=20
> > =20
> >=20
> > Any ideas on it? thanx.
> >=20
> > =20
> >=20
> > Aaron
> >=20
> > Intel China Software Lab
> >=20
> > Tel:  8621-52574545 Ext.1587
> >=20
> > E_mail:yukun.chen@intel.com
> >=20
> > =20
> >=20
>=20
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel@oss.oracle.com
> > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>=20
> --
> Mark Fasheh
> Software Developer, Oracle Corp
> mark.fasheh@oracle.com


--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
