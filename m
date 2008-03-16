From: Coly Li <coyli@suse.de>
Date: Sun Mar 16 21:10:56 2008
Subject: [Ocfs2-devel] how to use run_lvb_torture.py ?
In-Reply-To: <1205278329-11111-19-git-send-email-sunil.mushran@oracle.com>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
	<1205278329-11111-19-git-send-email-sunil.mushran@oracle.com>
Message-ID: <47DDF1CD.50901@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When I tried to run run_lvb_torture.py, there were some parameters I don't know how to use.

From the usage information,
run_lvb_torture.py [-d | --dlmfs <dlmfs path>] [-i | --iteractions <iteractions>] [-H | --hbdev
<heartbeat device>] [-l | --logfile <logfile>] [-n | --nodelist <nodelist>] <domain> <lockname>
[-h|--help]

1) what is heartbeat device? Should I create a separated ocfs2 partition as a heartbeat device ?
2) what is domain and lockname ? how to set it ?

I tried to google it and check the code, since I do not have clear conception for domain/lockname,
the information was very limited for me.

Thanks in advance.

-- 
Coly Li
SuSE PRC Labs
