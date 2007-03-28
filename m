From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Wed Mar 28 09:23:53 2007
Subject: [Ocfs2-devel] mount gnenerates an error : "Unable to access
	cluster service while starting heartbeat"
In-Reply-To: <147a89290703280827w67339993y32557cfd8067733a@mail.gmail.com>
References: <147a89290703280827w67339993y32557cfd8067733a@mail.gmail.com>
Message-ID: <460A968D.4030204@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

That might because you have configured user mode dlm. What does "|cat 
/sys/o2cb/heartbeat_mode" show, "user"?. If so run, /etc/init.d/o2cb 
configure and answer "n" for the following
||Use user-space driven heartbeat? (y/n) [y] n

thanks,
--Srini
||

|Andy Johnson wrote:
> Hello,
> I have ocfs2-tools-1.2.3. ( built from sources)
> I try:
>  mount /dev/vg1/cluster /mnt/ocfs2/
> and get:
> ocfs2_hb_ctl: Unable to access cluster service while starting heartbeat
> mount.ocfs2: Error when attempting to run /sbin/ocfs2_hb_ctl: 
> "Operation not permitted"
>
> What can be the cause of this error ? Any ideas?
>
> (I tried it after service heartbeat stop)
>
> Regards,
> Andy
> ------------------------------------------------------------------------
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
