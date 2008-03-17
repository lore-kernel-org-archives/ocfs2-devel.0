From: Marcos E. Matsunaga <Marcos.Matsunaga@oracle.com>
Date: Mon Mar 17 05:09:24 2008
Subject: [Ocfs2-devel] how to use run_lvb_torture.py ?
In-Reply-To: <47DDF1CD.50901@suse.de>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>	<1205278329-11111-19-git-send-email-sunil.mushran@oracle.com>
	<47DDF1CD.50901@suse.de>
Message-ID: <47DE5F27.3000508@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Coly,

You don't have to specify the hbdev. You will have the partition mounted 
to run this test.

Make sure you set /dlm directory to 777. The user needs to have full 
access to /dlm.

The domain is the UUID of the volume you are using.

debugfs.ocfs2 -R stats <device> |grep UUID

As for the lockname, I usually choose the biggest file I have on the 
partition.

To get the lockname:


debugfs.ocfs2 -R "encode <filepath>" <device>



Regards,

Marcos Eduardo Matsunaga

Oracle USA
Linux Engineering

?The statements and opinions expressed here are my own and do not
necessarily represent those of Oracle Corporation.?



Coly Li wrote:
> When I tried to run run_lvb_torture.py, there were some parameters I don't know how to use.
>
> >From the usage information,
> run_lvb_torture.py [-d | --dlmfs <dlmfs path>] [-i | --iteractions <iteractions>] [-H | --hbdev
> <heartbeat device>] [-l | --logfile <logfile>] [-n | --nodelist <nodelist>] <domain> <lockname>
> [-h|--help]
>
> 1) what is heartbeat device? Should I create a separated ocfs2 partition as a heartbeat device ?
> 2) what is domain and lockname ? how to set it ?
>
> I tried to google it and check the code, since I do not have clear conception for domain/lockname,
> the information was very limited for me.
>
> Thanks in advance.
>
>   
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080317/2472680d/attachment.html
