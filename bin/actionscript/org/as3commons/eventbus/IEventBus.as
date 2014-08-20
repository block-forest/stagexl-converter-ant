/*
 * Copyright 2007-2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.eventbus {
	import flash.events.Event;
	import org.as3commons.reflect.MethodInvoker;

	/**
	 * Describes an object that functions as an <code>ISimpleEventbus</code> but adds extra functionality that allows events and listeners to be intercepted
	 * and modified.
	 * <p>Events can be modified or blocked using <code>IEventInterceptor</code> implementations.</p>
	 * <p>Events listeners can be blocked using <code>IEventListenerInterceptor</code> implementations.</p>
	 * <p>Events listener proxiess can be blocked or modified using <code>IEventListenerInterceptor</code> implementations.</p>
	 * @author Roland Zwaga
	 */
	public interface IEventBus implements EventDispatcher /*extends ISimpleEventBus*/ {

		/**
			NOTE EventBus will get an overhaul for Dart, for now, we'll just extend EventDispatcher  
		*/
	}
}
