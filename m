From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Aug 24 13:41:51 2004
Subject: [Ocfs2-devel] [2.6.6 svn 1364]System hang randomly when writing
	to the same file from different processes of the same node
In-Reply-To: <B44D37711ED29844BEA67908EAF36F039EA49C@pdsmsx401.ccr.corp.intel.com>
References: <B44D37711ED29844BEA67908EAF36F039EA49C@pdsmsx401.ccr.corp.intel.com>
Message-ID: <20040824184144.GB1094@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 23, 2004 at 10:51:30AM +0800, Chen, Yukun wrote:
> Hi Mark
> 
> I checked the version and found 1364 on both nodes. 
Ok. what messages do you see on "node B" when this happens on A? Is node B
doing anything in particular?

> Also, I attached the test cases for duplicating such bug.
I might've bitten off more than I can chew by asking for that test code :) I
wrote a simple program to write in one place on a file (and I run this
twice) and I couldn't reproduce it yet. Looking through your test scripts it
seems that's basically what's going on, but please fill me in on any steps
I've missed. I guess I'm looking for an easily reproducable test case. Does
this happen every time you run your test suite or is it intermittent?
	--Mark

> 
> The steps to run the test case:
> 
> 1. make sure you have setup the tvs environment
> 
> 2. make sure the two test machine can ssh each other as root without password 
> 
> 3.update the variable OCFSDEV in test.config to the device name of your ocfs2 partition
> 
> 4.update the variable REMOTE in setup.sh to the remote machine name
> 
> 5.make sure you have created dir /ocfs (I will updated it later to an arbitrary dir which the user can change in the latter version)
> 
> 6.run "test_filelock.sh"
> 
> Feel free let me if you have any problems. 
> Thanx.
> 
> Aaron
> 
> -----Original Message-----
> From: Mark Fasheh [mailto:mark.fasheh@oracle.com] 
> Sent: 2004??8??21?? 1:43
> To: Chen, Yukun
> Cc: ocfs2-devel@oss.oracle.com
> Subject: Re: [Ocfs2-devel] [2.6.6 svn 1364]System hang randomly when writing to the same file from different processes of the same node
> 
> 
> Are all your nodes updated to r1364 btw? That'd make a big difference as the
> voting flags got juggled around a bit (sorry!) Otherwise it looks like it's
> hung doing a TRUNCATE_PAGES message which would be very troubling indeed. If
> both nodes *are* in fact, running 1364, you mind posting your test code up
> so I can give it a try? Thanks,
> 	--Mark
> 
> On Fri, Aug 20, 2004 at 04:24:37PM +0800, Chen, Yukun wrote:
> > Hi all
> >
> > 
> > Steps to duplicate:
> > 
> > 1.Do some operation ,such as mkdir&touch , on node A and node B
> > 
> >  
> > 
> > 2.on node A process1  write to a file at a specific position(such as offset
> > 1000) ,100 times
> > 
> >  
> > 
> > 2.also on node A, at the same time , process2 write to the same file at the
> > 
> >  
> > 
> > same position, 100 times
> > 
> >  
> > 
> > Repeat step 1-2 several times, system will hang with the following message
> > found in node A:
> > 
> >  
> > 
> > state=1, lockid=22765568, flags = 0x1000, asked type = 5 master = 1, state =
> > 0x0, type = 5
> > 
> > (18397) ERROR at /tmp/trunk/src/dlm.c, 461: status = -110
> > 
> > (18397) ERROR at /tmp/trunk/src/vote.c, 910: inode 5558, vote_status=0,
> > vote_state=1, lockid=22765568, flags = 0x1000, asked type = 5 master = 1, state
> > = 0x0, type = 5
> > 
> > ...
> > 
> >  
> > 
> > on node B , error message with dmesg:
> > 
> > Call Trace:
> > 
> > recalc_task_prio
> > 
> > shedule
> > 
> > ocfs_comm_process_msg
> > 
> > ocfs_dlm_recv_msg
> > 
> > worker_thread
> > 
> > ocfs_dlm_recv_msg
> > 
> > default_wake_function
> > 
> > ....
> > 
> >  
> > 
> > Any ideas on it? thanx.
> > 
> >  
> > 
> > Aaron
> > 
> > Intel China Software Lab
> > 
> > Tel:  8621-52574545 Ext.1587
> > 
> > E_mail:yukun.chen@intel.com
> > 
> >  
> > 
> 
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel@oss.oracle.com
> > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> --
> Mark Fasheh
> Software Developer, Oracle Corp
> mark.fasheh@oracle.com


--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
