package org.lucee.extension.sysmon.functions;

import oshi.SystemInfo;
import oshi.hardware.CentralProcessor;
import lucee.runtime.PageContext;
import lucee.runtime.exp.PageException;

public class GetCPUUsage extends FunctionSupport {

	private static final long serialVersionUID = 1L;

	@Override
	public Object invoke(PageContext pc, Object[] args) throws PageException {
		return call(pc);
	}

	public static double call(PageContext pc) {
		SystemInfo si = new SystemInfo();
		CentralProcessor cpu = si.getHardware().getProcessor();
		return cpu.getSystemCpuLoad(1000) * 100;
	}

}
