From: Sami <techker_s@yahoo.com>
Date: Wed Sep  8 13:43:23 2004
Subject: [Ocfs2-devel] HELP! PRKR-1025 error
Message-ID: <20040908184318.36460.qmail@web61003.mail.yahoo.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I am installing per
http://www.oracle.com/technology/pub/articles/hunter_rac.html#FireWire%20Technology

I am getting a PRKR-1025 error. The
$ORACLE_HOME/root.sh doesnt not create any entry for
srvconfig_loc in the srvConfig.loc file

$ srvconfig -init

PRKR-1025 error when attempting to run the srvconfig
-init command, check that you have the valid entry for
"srvconfig_loc" in your /var/opt/oracle/srvConfig.loc
file and that the file is owned by "oracle". This
entry gets created by the root.sh.

Plus, the root.sh doesnt have line 249 with OPS_CONFIG
as stated in
http://www.oracle.com/technology/pub/articles/hunter_rac.html#FireWire%20Technology


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
